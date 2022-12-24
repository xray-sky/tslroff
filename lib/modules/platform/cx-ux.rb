# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Concurrent CX/UX Platform Overrides
#
# TODO
#
#   font shme: \f3 (if not bold), \f4, \f5, \fl
#   extensive use of \f4 (which is... what?)
#   use of \fL right next to \f4 in acc_vector(4) so probably that's not in the running
#   use of \fl in sar(1m) - what is that
#   use of \f5 in sendmail(1m), addseverity(3c), fmtmsg(3c), admin(1) - what is that, maybe CW. used in section 3c for console output
#   use of \f3 in several pages in section 7 - for subsection head, and once in text as emphasis (almost certainly plain bold)
#   use of \f3 in ar(4), fs(4)
#

module CX_UX

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.(\d\S*)(?:\.z)?$/, '') # nroff pages are compressed
    k.instance_variable_set '@manual_section', Regexp.last_match[1] if Regexp.last_match
  end

  def init_ds
    super
    @state[:named_string].merge!({
      #'Tm' => '&trade;',
      ']W' => File.mtime(@source.filename).strftime("%B %d, %Y"),
      :footer => "\\*(]W"
    })
  end

  def init_fp
    super
    # REVIEW - going with solaris troff assignments:
    @state[:fonts][4] = 'BI' # not fully convinced of this one
    @state[:fonts][5] = 'CW'
    # still don't know what \fl is
  end

  def init_tr
    super
    @state[:translate]['*'] = "\e(**"
  end

  def init_TH
    #super
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

  define_method 'TH' do |*args|
    #req_ds ']W 7th Edition' # tmac.an.new
    #req_ds ']D 32B Virtual UNIX Programmer\'s Manual' # tmac.an.new
    req_ds "]L #{args[2]}"
    req_ds "]W #{args[3]}"
    req_ds "]D #{args[4]}"

    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)"
    heading << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?
    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]D' unless @state[:named_string][']D'].empty?

    super(*args, heading: heading)
  end

end
