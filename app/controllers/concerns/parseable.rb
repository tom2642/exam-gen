# frozen_string_literal: true
require 'pandoc-ruby'

module Parseable
  def docx_to_md(uploaded_file, billy)
    # write the tmp file io object to a file
    return others_parse(uploaded_file) if billy == 'false'
    return billy_parse(uploaded_file)
  end

  private

  def billy_parse(uploaded_file)
    results = []
    # convert the docx into string(markdown) and seperate the string into questions
    raw_strings = PandocRuby.convert(uploaded_file, '--from=docx', '--to=markdown', '--extract-media=tmp/')
                            .split(/Short Questions/)
    raw_strings.delete_at(1) # delete short questions
    raw_strings = raw_strings.first.split(/Question code: .+\n\n/) # split into seperate questions
    topic = raw_strings.first.gsub(/\*\*Chapter \d+ /, '').gsub(/\*\*[\s\S]+/, '') # parse topic
    raw_strings.delete_at(0) # delete the part before the first question
    # raw_string #=> Question...\n\nA. Choice...\n\nAnswer:\n\nB\n\n....

    raw_strings.each_with_index do |raw_string, index|
      # seperate images into different folder, each folder for one question
      move_images_into_sub_folders(raw_string, index) if %r{.*!\[]\(tmp.*}.match?(raw_string)

      splited_strings = raw_string.strip.split(/Answer:\W*/) # [0] #=> question and choices, [1] #=> answer

      # Parse question
      question_and_choices = splited_strings.first.strip.split('A. ')
      question = question_and_choices.first.strip.gsub('> ', '').gsub("\n>\n", "\n\n").split("\n\n") # strip unwanted markdown code
      question.each { |line| line.gsub!(/\*\*/, '') unless line.include?('-------') } # remove bold unless table

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

  def others_parse(uploaded_file)
    raise
    results = []
    raw_strings = PandocRuby.convert(uploaded_file, '--from=docx', '--to=markdown', '--extract-media=tmp/')
                            .split("\\[Question\\]\n\n")
    raw_strings.delete_at(0)
    # raw_string #=> [Question]...[Choices]...[Answer]\n\nB\n\n[Topic]....

    raw_strings.each_with_index do |raw_string, index|
      # seperate images into different folder, each folder for one question
      move_images_into_sub_folders(raw_string, index) if %r{.*!\[]\(tmp.*}.match?(raw_string)

      splited_strings = raw_string.strip.split("\n\n\\[Answer\\]\n\n") # [0] #=> question, choices, [1] #=> answer, topic

      question = splited_strings.first.split("\n\n\\[Choices\\]\n\n").first.split("\n\n")
      question.each { |line| line.gsub!(/\*\*/, '') unless line.include?('-------') } # remove bold unless table

      choices = splited_strings.first.split("\n\n\\[Choices\\]\n\n")[1].split("\n\n")
      alphabet = ('A'..'Z').to_a
      choices.each_with_index do |choice, i|
        choices[i] = choice[0] == '(' ? "#{alphabet[i]}.  \\#{choice}" : "#{alphabet[i]}.  #{choice}"
      end

      answer = splited_strings[1][0]

      topic = if splited_strings[1].include?('Topic')
                splited_strings[1].split("\n\n\\[Topic\\]\n\n")[1].split("\n\n\\[Topic\\]\n\n").first
              else
                "Other"
              end

      results.push({ question: question, choices: choices, answer: answer, topic: topic })
    end
    return results
  end

  def move_images_into_sub_folders(raw_string, index)
    FileUtils.mkdir_p("tmp/media/#{index}") # create a folder for every questions that have images
    raw_string.scan("![](tmp").size.times do
      # For question having n images, move the first n images in media/ to media/#{index}/
      first_image = Dir["tmp/media/*"].select { |path| path.include?("image") }.min # only select the files
      FileUtils.mv first_image, "tmp/media/#{index}/#{first_image.gsub('tmp/media/', '')}"
    end
  end
end
