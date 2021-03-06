# frozen_string_literal: true
require 'pandoc-ruby'

module DocxConvertable
  def send_docx(selected_questions)
    # set file name before sending
    fname = "grade#{selected_questions.first.subject[:grade]}_#{selected_questions.first.subject[:name]}"
    send_data md_to_docx(selected_questions), filename: "#{fname}.docx"
  end

  private

  # transform markdown from db into docx with correct formatting
  def md_to_docx(selected_questions)
    result_string = "There are #{selected_questions.size} questions in this paper. Choose the **BEST** answer for\neach question.\n\n**1 question, 1 mark.**\n\n<br>\n\n" # markdown
    # transform questions into numbered list in docx
    selected_questions.each_with_index do |selected_question, i|
      result_string += "#{i + 1}.  " # 2 trailing spaces = cast the whole quesiton into a list item
      result_string += "#{selected_question[:question][0]}\n\n" # first line of quesiton, \n\n = next line
      selected_question[:question][1..].each { |line| result_string += "    #{line}\n\n" } # 4 leading spaces = same list item

      selected_question[:choices]&.each { |choice| result_string += "    #{choice}\n\n" } # Insert choices, 4 leading spaces = same list item
      result_string += "<br>\n\n" # empty line after whole question
    end
    result_string += "<br>\n\n**END OF PAPER**\n"

    return PandocRuby.convert(result_string, '--from=markdown', '--to=docx')
  end
end
