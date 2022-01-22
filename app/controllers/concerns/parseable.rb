# frozen_string_literal: true
require 'pandoc-ruby'

module Parseable
  def parse(uploaded_file)
    # write the tmp file io object to a file
    File.open(Rails.root.join('tmp', 'docx', uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end

    # convert the docx into string(markdown) and split into seperate questions
    raw_strings = PandocRuby.convert(["tmp/docx/#{uploaded_file.original_filename}"], '--from=docx', '--to=markdown', '--extract-media=tmp/')
                            .split(/Question code: .+\n\n/)
    topic = raw_strings.first.gsub(/\*\*Chapter \d+ /, '').gsub(/\*\*[\s\S]+/, '')
    raw_strings.delete_at(0) # delete the part before the first question
    # raw_string #=> Question...\n\nA. Choice...\n\nAnswer:\n\nB\n\n....
    File.delete(Rails.root.join('tmp', 'docx', uploaded_file.original_filename)) # delete the docx

    results = []
    raw_strings.each_with_index do |raw_string, index|
      # seperate images into different folder, each folder for one question
      if %r{.*!\[]\(tmp.*}.match?(raw_string)
        FileUtils.mkdir_p("tmp/media/#{index}") # create a folder for every questions that have images
        raw_string.scan("![](tmp").size.times do
          # For question having n images, move the first n images in media/ to media/#{index}/
          first_image = Dir["tmp/media/*"].select { |path| path.include?("image") }.min # only select the files
          FileUtils.mv first_image, "tmp/media/#{index}/#{first_image.gsub('tmp/media/', '')}"
        end
      end

      splited_strings = raw_string.strip.split("Answer:\n\n") # [0] #=> question and choices, [1] #=> answer

      # Parse question
      question_and_choices = splited_strings.first.strip.split('A. ')
      question = question_and_choices.first.strip.gsub('> ', '').gsub("\n>\n", "\n\n").split("\n\n") # strip unwanted markdown code
      question.each { |line| line.gsub!(/\*\*/, '') unless line.include?('-------') } # remove bold unless table
      question[0] = "#{question[0]}\n\n" # first line of quesiton, \n\n = next line
      question[1..].each_with_index { |line, i| question[i + 1] = "    #{line}\n\n" } # 4 leading spaces = list item
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
      results.push({ question: question, choices: choices, answer: answer, topic: topic })
    end
    return results
  end
end
