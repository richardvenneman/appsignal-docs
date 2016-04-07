# From: https://github.com/hashicorp/middleman-hashicorp/blob/master/lib/middleman-hashicorp/redcarpet.rb

require "middleman-core"
require "middleman-core/renderers/redcarpet"
require "active_support/core_ext/module/attribute_accessors"

class AppsignalMarkdown < ::Middleman::Renderers::MiddlemanRedcarpetHTML

  def paragraph(text)
    add_notices("<p>#{text.strip}</p>\n")
  end

  private

  def add_notices(text)
    map = {
      "-&gt;" => "notice",
    }

    regexp = map.map { |k, _| Regexp.escape(k) }.join("|")

    if md = text.match(/^<p>(#{regexp})/)
      key = md.captures[0]
      klass = map[key]
      text.gsub!(/#{Regexp.escape(key)}\s+?/, "")

      return <<-EOH.gsub(/^ {8}/, "")
        <div class="#{klass}">
        #{text}</div>
      EOH
    else
      return text
    end
  end
end
