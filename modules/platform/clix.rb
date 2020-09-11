# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Intergraph CLIX Platform Overrides
#

module CLIX

  Manual.define_singleton_method :related_info_heading do
    'RELATED INFORMATION'
  end

  def load_version_overrides
    @heading_detection = %r(^  ([A-Z][A-Za-z\s]+)$)
    super
  end

  def init_clix
    @manual_entry     = @input_filename.sub(/\.([\dZz]\S?)$/, '')
  end

end


