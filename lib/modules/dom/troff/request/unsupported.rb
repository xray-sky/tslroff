# this is the approximate distance by which we fall short of a complete troff implementation

module Troff

  def req_ab(argstr = '', breaking: nil)
    warn ".ab wants to abort processing"
  end

  def req_bd(argstr = '', breaking: nil)
    warn ".bd wants to change emboldening: #{argstr.inspect}"
  end

  def req_cf(argstr = '', breaking: nil)
    warn ".cf wants to copy in file: #{argstr.inspect}"
  end

  def req_ch(argstr = '', breaking: nil)
    warn ".ch wants to change trap position: #{argstr.inspect}"
  end

  def req_em(argstr = '', breaking: nil)
    warn ".em wants to set EOF trap macro: #{argstr.inspect}"
  end

  # how is this different from .ab? just exit code?
  def req_ex(argstr = '', breaking: nil)
    warn ".ex wants to exit processing"
  end

  def req_fl(argstr = '', breaking: nil)
    warn ".fl wants to flush output buffer"
  end

  def req_lc(argstr = '', breaking: nil)
    warn ".lc wants to change leader fill repetition character to: #{argstr.inspect}"
  end

  # TODO implementing this could allow .so to make use of
  def req_lf(argstr = '', breaking: nil)
    warn ".lf wants to correct input line number to: #{argstr.inspect}"
  end

  def req_ll(argstr = '', breaking: nil)
    warn ".ll wants to change line length to: #{argstr.inspect}"
  end

  def req_ls(argstr = '', breaking: nil)
    warn ".ls wants to change line spacing to: #{argstr.inspect}"
  end

  def req_lt(argstr = '', breaking: nil)
    warn ".lt wants to change title line length to: #{argstr.inspect}"
  end

  def req_mc(argstr = '', breaking: nil)
    warn ".mc wants to set margin character: #{argstr.inspect}"
  end

  def req_mk(argstr = '', breaking: nil)
    warn ".mk wants to save current vertical position in register: #{argstr.inspect}"
  end

  def req_nm(argstr = '', breaking: nil)
    warn ".nm wants to enable line numbering: #{argstr.inspect}"
  end

  def req_nn(argstr = '', breaking: nil)
    warn ".nn wants to disable line numbering"
  end

  def req_nx(argstr = '', breaking: nil)
    warn ".nx wants to switch to input file #{argstr.inspect}"
  end

  def req_os(argstr = '', breaking: nil)
    warn ".os wants to output saved vertical space"
  end

  def req_pc(argstr = '', breaking: nil)
    warn ".pc wants to change page number character: #{argstr.inspect}"
  end

  def req_pi(argstr = '', breaking: nil)
    warn ".pi wants to pipe output to program: #{argstr.inspect}"
  end

  def req_pl(argstr = '', breaking: nil)
    warn ".pl wants to change page length: #{argstr.inspect}"
  end

  def req_pm(argstr = '', breaking: nil)
    warn ".pm wants to print macros: #{argstr.inspect}"
  end

  def req_pn(argstr = '', breaking: nil)
    warn ".pn wants to change page number to: #{argstr.inspect}"
  end

  def req_po(argstr = '', breaking: nil)
    warn ".po wants to change page offset (left margin): #{argstr.inspect}"
  end

  def req_rd(argstr = '', breaking: nil)
    warn ".rd wants to read from stdin with prompt #{argstr.inspect}"
  end

  def req_rt(argstr = '', breaking: nil)
    warn ".rt wants to return to saved vertical position, with optional offset: #{argstr.inspect}"
  end

  def req_sv(argstr = '', breaking: nil)
    warn ".sv wants to save vertical space of height: #{argstr.inspect}"
  end

  def req_tc(argstr = '', breaking: nil)
    warn ".tc wants to change tab fill repetition character to: #{argstr.inspect}"
  end

  def req_tl(argstr = '', breaking: nil)
    warn ".tl wants to output three part title: #{argstr.inspect}"
  end

  def req_wh(argstr = '', breaking: nil)
    warn ".wh wants to set page trap: #{argstr.inspect}"
  end

end
