# frozen_string_literal: true
require 'pandoc-ruby'

module HtmlConvertable
  def md_to_html(questions)
    questions_and_htmls = []
    questions.each do |question|
      questions_and_htmls.push(
        {
          question: question,
          html: PandocRuby.convert("#{question[:question].join("\n\n")}\n\n#{question[:choices]&.join("\n\n")}",
                                   '--from=markdown', '--to=html')
        }
      )
    end

    return questions_and_htmls
  end

  def replace_image_local_path_with_url(questions)
    questions.each do |question|
      question.images.each do |image|
        question.question.each do |line|
          line.gsub!(%r{!\[\]\(tmp//media/.*\)}, "![](#{image.url})") if line.include?(image.filename.to_s)
        end
      end
    end
  end
end
