# frozen_string_literal: true
require 'pandoc-ruby'

module Parseable
  def parse(uploaded_file)
    File.open(Rails.root.join('tmp', 'docx', uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end

    raw_strings = PandocRuby.convert(["tmp/docx/#{uploaded_file.original_filename}"], '--from=docx', '--to=markdown', '--extract-media=tmp/')
                            .split(/Question code: .+\n\n/)
    raw_strings.delete_at(0)
    # raw_string #=> Question...\n\nA. Choice...\n\nAnswer:\n\nB\n\n....
    File.delete(Rails.root.join('tmp', 'docx', uploaded_file.original_filename))

    results = []
    raw_strings.each do |raw_string|
      splited_strings = raw_string.strip.split("Answer:\n\n") # [0] #=> question and choices, [1] #=> answer

      # Parse question
      question_and_choices = splited_strings.first.strip.split('A. ')
      question = question_and_choices.first.strip.gsub('> ', '').gsub("\n>\n", "\n\n").split("\n\n") # strip unwanted markdown code
      question.each { |line| line.gsub!(/\*\*/, '') unless line.include?('-------') } # remove bold unless table
      question[0] = "#{question[0]}\n\n" # first line of quesiton, \n\n = next line
      question[1..-1].each_with_index { |line, i| question[i + 1] = "    #{line}\n\n" } # 4 leading spaces = list item
      question = question.join

      # Parse choices
      unless question_and_choices[1].nil? # choice is not nil(due to not supporting alt content of docx)
        choices = "A. #{question_and_choices[1]}".strip.split("\n\n") # split choices (A/B/C/D) into an array
        choices.each do |choice|
          choice.gsub!(/[A-Z]\. \(/, "#{choice[0]}. \\(") # change ( to \\( due to markdown format
          choice.gsub!(/[A-Z]\. /, "#{choice[0]}.  ") # 2 spaces = cast choices into a list
        end
      end

      answer = splited_strings[1][0] # parse answer
      results.push({ question: question, choices: choices, answer: answer })
    end
    return results
  end
end
