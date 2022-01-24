# frozen_string_literal: true
require 'pandoc-ruby'

module HtmlConvertable
  def md_to_html(questions)
    mds = []
    questions.each do |question|
      mds.push("#{question[:question].join("\n\n")}\n\n#{question[:choices]&.join("\n\n")}")
    end

    htmls = []
    mds.each do |md|
      htmls.push(PandocRuby.convert(md, '--from=markdown', '--to=html'))
    end
    return htmls
  end
end
