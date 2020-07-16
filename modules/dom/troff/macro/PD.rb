# PD.rb
# -------------
#   troff
# -------------
#
#   .PD v
#
#     Set the interparagraph distance to v vertical spaces. If v is omitted, the set the
#     interparagraph distance to the default value (0.4v in troff(1), 1v in nroff(1)).
#
#     just sets )P, does nothing to @current_block
#     some implementations set PD instead
#
#     tslroff.css has it as 1em, which is some kind of de-facto browser standard.
#     I think this is better for HTML than 0.4v (0.48em). REVIEW: if we decide to change
#     it later, the CSS should be updated (for p, dl, others?)
#

module Troff

  def req_PD(v = nil)
    v ? @register[')P'].value = to_u(v) : init_PD
  end

  def init_PD
    @state[:default_pd] = to_u('1m').to_i
    @register[')P'] = Register.new(@state[:default_pd])
  end

end
