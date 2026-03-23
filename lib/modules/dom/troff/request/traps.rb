# it.rb
# -------------
#   troff
# -------------
#
#   §7.5
#
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
#
# .di xx         -        end       D       Divert output to macro xx.
#                                           Normal text processing occurs during
#                                           diversion except that page offsetting is not
#                                           done. The diversion ends when the request .di
#                                           or .da is encountered without an argument;
#                                           extraneous requests of this type should not
#                                           appear when nested diversions are being used.
#
# .da xx         -        end       D       Divert, appending to xx (append version of .di)
#
# appending a not-previously defined diversion is allowed
#
#   REVIEW is .di the reason we're ending up with short left margins in e.g. the man(5)s ?
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
#

class Troff
  def so(argstr = '', breaking: nil, basedir: nil)
    return nil if argstr.empty?
    name = argstr.split.first

    # make this relative by trying to find file working backward
    # NOTE this is relative _to the man page directory_ (@source.dir)
    # REVIEW will we ever see a non-absolute path here, that we could maybe use directly?
    file = File.basename name
    basedir ||= @source.dir
    searchdir = ''
    path_components = File.dirname(name).split('/').reverse
    until File.readable?("#{basedir}/#{searchdir}#{file}") do
      return(nil).tap { warn ".so can't read #{name}" } if path_components.empty?
      searchdir = "#{path_components.shift}/#{searchdir}"
    end

    localfile = File.realpath("#{basedir}/#{searchdir}#{file}")

    # REVIEW this is a bit suspect; makes rewrites look ugly
    # might benefit from a full Manual.new & subsequent merge? maybe.

    olines = @lines
    ofile = @input_filename.dup
    opos = @register['.c'].dup
    ochain = @so_chain
    @so_chain ||= ''
    @so_chain << " [#{opos}] => .so #{file}"  # TODO still awkward, at least functional for now
    @register['.c'] = Register.new(0, 1, :ro => true)
    newsrc = File.read(localfile).lines
    newsrc = yield newsrc if block_given? # give a chance to perform processing on the sourced file
    @lines = newsrc.each

    loop do
      begin
        parse(next_line)
      rescue StopIteration
        break
      end
    end

    @lines = olines
    @input_filename = ofile
    @register['.c'] = opos
    @so_chain = ochain
  end

  def da(argstr = '', breaking: nil)
    macro = argstr.slice(0, 2).strip
    unless macro.empty?
      warn ".da appending diversion #{macro.inspect}"
      @state[:diversion_stack] << @current_block
      @current_block = blockproto
      @state[:diversions][macro] ||= [] # .da of a not-previously .di'ed macro is the same as .di'ing it
      @state[:diversions][macro] << @current_block
      define_singleton_method macro do |*args|
        warn "inserting diversion #{macro.inspect}"
        @document += @state[:diversions][macro]
      end unless macro == :selenium or respond_to? macro
    else
      warn ".da ending prior diversion"
      @current_block = @state[:diversion_stack].pop
    end
  end

  def di(argstr = '', breaking: nil)
    macro = argstr.slice(0, 2).strip
    unless macro.empty?
      warn ".di creating diversion #{macro.inspect}"
      @state[:diversion_stack] << @current_block
      @current_block = blockproto
      @state[:diversions][macro] = [ @current_block ]
      define_singleton_method macro do |*args|
        warn "inserting diversion #{macro.inspect}"
        @document += @state[:diversions][macro]
      end unless macro == :selenium
    else
      warn ".di ending prior diversion"
      @current_block = @state[:diversion_stack].pop
    end
  end

  def dt(argstr = '', breaking: nil)
    (pos, macro) = argstr.split
    if pos and macro
      warn "!! setting diversion trap #{pos.inspect} #{macro.inspect}"
      pos = to_u(pos).to_i
      @state[:diversion_trap][pos] ||= []
      @state[:diversion_trap][pos] << [ macro, args ]
    else
      warn "clearing all diversion traps due to .dt #{pos.inspect} #{macro.inspect}"
      init_dt
    end
  end

  def it(argstr = '', breaking: nil)
    (count, macro) = argstr.split
    if count and macro and respond_to?(macro)
      count = count.to_i
      @state[:input_trap][count] ||= []
      @state[:input_trap][count] << [ macro ]
    else
      warn "clearing all input traps due to .it #{count.inspect} #{macro.inspect}"
      init_it
    end
  end

  def init_di
    @state[:diversion_stack] = []
    @state[:diversions] = {
      :selenium => []
    }
  end

  def init_dt
    @state[:diversion_trap] = Hash.new
  end

  def init_it
    @state[:input_trap] = Hash.new
  end

  def init_traps
    init_di
    init_dt
    init_it
  end

end
