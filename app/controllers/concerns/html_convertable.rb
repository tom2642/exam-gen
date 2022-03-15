# frozen_string_literal: true
require 'pandoc-ruby'

module HtmlConvertable
  # transform markdown to html in order to display question previews in user's browser
  def md_to_html(questions)
    questions_and_htmls = []
    questions.each do |question|
      questions_and_htmls.push(
        {
          question: question,
          # combine the :question and :choices columns into one html
          html: PandocRuby.convert("#{question[:question].join("\n\n")}\n\n#{question[:choices]&.join("\n\n")}",
                                   '--from=markdown', '--to=html')
        }
      )
    end

    return questions_and_htmls
  end
end
