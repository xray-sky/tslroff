# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# OSF/1 & Digital UNIX (Tru64) Platform Overrides
#
# to_html for C++ 6.2 - serviceable;
# wants some source rewriting for full output correctness (js, css, etc.)
# wants some decisions about our styles vs. theirs, where ours (less ugly) are taking precedence
# TODO
#    nuke their imagemap links
# √  .htm.html (internal links too) REVIEW is working though? how??
#    REVIEW keep their index.htm?
#

module OSF1

  class HTML < HTML
    def page_title
      "#{xpath('//head/title').text} &mdash; #{@platform} #{@version}"
    end

    def index_description
      hdescr = xpath('//h1')[0..1].map { |e| e.children.map { |x| x.name == 'br' ? ' ' : x.text } .join }.join(' :: ')
      hdescr.empty? ? xpath('//head/title').text : hdescr
    end
  end

end
