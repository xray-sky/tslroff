# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/26/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# QNX Momentics Platform Overrides
#
# TODO
#   get manual_section more granular for the html help files (not just top level directory)
#

module Momentics
  class HTML < HTML

    def initialize(source, **kwargs)
      super
      @manual_section = basedir
    end

    def to_html(halt_on: nil)
      return if halt_on
      body = xpath('//body')

      # somehow the <table align="left"> messes up the box model. idk?
      body.css('table').each do |tbl|
        tbl.delete('align') if tbl['align']&.downcase == 'left'
      end

      super
    end

    private

    def docdir
      @docdir ||= @source.dir.partition(%r{^.*/(?:usr/help)/?}).last
    end

    def basedir
      @basedir ||= docdir.split('/').drop(1).map { |d| d.tr('_', ' ').capitalize.delete_suffix ' en' }.join(' :: ')
    end

  end
end
