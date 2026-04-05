# frozen_string_literal: true
#
# traps.rb
# -------------
#   troff
# -------------
#
#   §7.5
#

class Troff
  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
  #
  # .da xx         -        end       D       Divert, appending to xx (append version of .di)
  #
  # appending a not-previously defined diversion is allowed

  def da(argstr = '', breaking: nil)
    macro = argstr[0, 2].strip
    unless macro.empty?
      warn ".da : appending diversion #{macro.inspect}"
      @diversion_stack << @current_block
      @current_block = blockproto
      @diversions[macro] ||= [] # .da of a not-previously .di'ed macro is the same as .di'ing it
      @diversions[macro] << @current_block
      define_singleton_method macro do |*args|
        warn ".da : inserting diversion #{macro.inspect}"
        @document += @diversions[macro]
      end unless macro == :selenium or respond_to? macro
    else
      warn ".da : ending prior diversion"
      @current_block = @diversion_stack.pop
    end
  end

  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
  #
  # .di xx         -        end       D       Divert output to macro xx.
  #                                           Normal text processing occurs during
  #                                           diversion except that page offsetting is not
  #                                           done. The diversion ends when the request .di
  #                                           or .da is encountered without an argument;
  #                                           extraneous requests of this type should not
  #                                           appear when nested diversions are being used.
  #
  #   REVIEW is .di the reason we're ending up with short left margins in e.g. the man(5)s ?

  def di(argstr = '', breaking: nil)
    macro = argstr[0, 2].strip
    unless macro.empty?
      warn ".di : creating diversion #{macro.inspect}"
      @diversion_stack << @current_block
      @current_block = blockproto
      @diversions[macro] = [ @current_block ]
      define_singleton_method macro do |*args|
        warn ".di : inserting diversion #{macro.inspect}"
        @document += @diversions[macro]
      end unless macro == :selenium
    else
      warn ".di : ending prior diversion"
      @current_block = @diversion_stack.pop
    end
  end

  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
  #
  # .dt N xx      -         off       D,v     Install a diversion trap at position N in
  #                                           the current diversion to invoke macro xx.
  #                                           Another .dt will redefine the diversion trap.
  #                                           If no arguments are given, the diversion trap
  #                                           is removed.
  #
  #  no idea how this is supposed to work, or how it can be made to work in HTML context
  #  so far the only use is cmp(1) [GL2-W2.5] and there are no args, so it's a no-op
  #
  #  REVIEW what happens when given not-an-N as first arg (invalid expression)
  #         ignored, I think, which means bad interaction from to_u returning '0' in that case

  def dt(argstr = '', breaking: nil)
    (pos, macro) = argstr.split
    if pos and macro
      warn ".dt : !! setting diversion trap #{pos.inspect} #{macro.inspect}"
      pos = to_u(pos).to_i
      @diversion_traps[pos] ||= []
      @diversion_traps[pos] << [ macro, args ]
    else
      warn ".dt : clearing all diversion traps due to args #{pos.inspect} #{macro.inspect}"
      init_dt
    end
  end

  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
  #
  # .it N xx      -         off       E       Set an input-line-count trap to invoke the
  #                                           macro xx after N lines of text input have
  #                                           been read (control or request lines don't
  #                                           count). The text may be in-line or trap-
  #                                           invoked macros representing text. (See the
  #                                           discussion of the input-line-count .it
  #                                           request in section 7.5, "Traps.")
  #
  #  REVIEW what happens when given not-an-N as first arg (invalid expression)
  #         ignored, I think, which means bad interaction from to_u returning '0' in that case
  #
  # we may enter .it with arbitrarily named macros, from renaming "internal" macros
  # like .}S to something more ruby-friendly

  def it(argstr = '', breaking: nil)
    (count, macro) = argstr.split
    if count and macro and respond_to?(macro)
      count = count.to_i
      @input_traps[count] ||= []
      @input_traps[count] << [ macro ]
    else
      warn ".it : clearing all input traps due to .it #{count.inspect} #{macro.inspect}"
      init_it
    end
  end

  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
  #
  # .so file      -         -         -       Switch source file. The top input (file reading)
  #                                           level is switched to file. When the new file
  #                                           ends, input is again taken from the original
  #                                           file; .so's may be nested. Note that file should
  #                                           be preprocessed, if necessary, before being
  #                                           called by .so. eqn, tbl, pic, and grap will
  #                                           not reach through .sos to process an object
  #                                           file. Once a .so is encountered, the processing
  #                                           of file is immediate. Processing of the original
  #                                           file (e.g., a macro that is still active) is
  #                                           suspended.

  def so(argstr = '', breaking: nil, basedir: nil, source_class: nil)
    return if argstr.strip.empty?
    name = argstr.split.first
    # make this relative by trying to find file working backward
    # NOTE this is relative _to the man page directory_ (@source.dir)
    # REVIEW will we ever see a non-absolute path here, that we could maybe use directly?
    sofile = File.basename name
    basedir ||= @source.dir
    searchdir = ''
    path_components = File.dirname(name).split('/').reverse
    until File.readable?("#{basedir}/#{searchdir}#{sofile}") do
      return(nil).tap { warn ".so : can't read #{sofile}" } if path_components.empty?
      searchdir = "#{path_components.shift}/#{searchdir}"
    end

    localfile = File.realpath("#{basedir}/#{searchdir}#{sofile}")

    opfx = @warn_prefix
    @warn_prefix = "#{@warn_prefix}#{file} [#{line_number}]: .so => "
    olines = @lines
    opos = @register['.c'].dup
    osrc = @source

    @source = (source_class || Source).new localfile
    @register['.c'] = Register.new(0, 1, :ro => true)
    @lines = @source.iter
    loop do
      begin
        parse(next_line)
      rescue StopIteration
        break
      end
    end

    @source = osrc
    @register['.c'] = opos
    @lines = olines
    @warn_prefix = opfx
  end

  # REVIEW how is it that this is not redundant?
  def init_traps
    init_di
    init_dt
    init_it
  end

  def init_di
    @diversion_stack = []
    @diversions = {
      :selenium => []
    }
  end

  def init_dt
    @diversion_traps = Hash.new
  end

  def init_it
    @input_traps = Hash.new
  end

  private

  def process_input_traps
    # decrement the line counters
    @input_traps = @input_traps.transform_keys { |k| k -= 1 }

    # select the ones that should happen now
    macros = @input_traps.delete(0)

    return unless macros
    macros.reverse.each do |macro|
      send macro[0]
    end
  end
end
