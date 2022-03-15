# frozen_string_literal: true
require 'pandoc-ruby'

module Parseable
  # the converted markdown is one long string
  # it needs to be seperated and formatted into different parts of the questions before saving to db
  def docx_to_md(uploaded_file, billy)
    # transform the tmp file io object into a local file
    return others_parse(uploaded_file) if billy == 'false'

    # billy_parse is only available for Billy as it specifically deals with question bank documents which only Billy possess
    return billy_parse(uploaded_file)
  end

  private

  def billy_parse(uploaded_file)
    results = []
    # convert the docx into string(markdown) and seperate the string into 2 parts(multiple chioces and short questions)
    raw_strings = PandocRuby.convert(uploaded_file, '--from=docx', '--to=markdown', '--extract-media=tmp/')
                            .split(/Short Questions/)
    raw_strings.delete_at(1) # delete short questions as only multiple choices questions are supported
    raw_strings = raw_strings.first.split(/Question code: .+\n\n/) # split seperate questions
    topic = raw_strings.first.gsub(/\*\*Chapter \d+ /, '').gsub(/\*\*[\s\S]+/, '') # get topic string without any irrelevant characters
    raw_strings.delete_at(0) # delete the part before the first question

    # raw_string #=> Question...\n\nA. Choice...\n\nAnswer:\n\nB\n\n....
    raw_strings.each_with_index do |raw_string, index|
      # save images into different folder, one folder for one question
      # ![](... is markdown syntax of image
      move_images_into_sub_folders(raw_string, index) if %r{.*!\[]\(tmp.*}.match?(raw_string)

      splited_strings = raw_string.strip.split(/Answer:\W*/) # [0] #=> question and choices, [1] #=> answer

      # Parse question
      question_and_choices = splited_strings.first.strip.split('A. ') # "A." indicates the start of choices
      question = question_and_choices.first.strip.gsub('> ', '').gsub("\n>\n", "\n\n").split("\n\n") # strip unwanted markdown code
      question.each { |line| line.gsub!(/\*\*/, '') unless line.include?('-------') } # remove bold markdown unless it's inside a table

      # Parse choices
      unless question_and_choices[1].nil? # choice is not nil(due to not supporting alt content of docx)
        choices = "A. #{question_and_choices[1]}".strip.split("\n\n") # split choices (A/B/C/D) into an array
        choices.each do |choice|
          choice.gsub!(/[A-Z]\. \(/, "#{choice[0]}. \\(") # change ( to \\( due to markdown format
          choice.gsub!(/[A-Z]\. /, "#{choice[0]}.  ") # 2 trailing spaces = cast choices into a list item
        end
      end

      answer = splited_strings[1][0] # parse answer
      results.push({ question: question, choices: choices, answer: answer, topic: topic })
    end
    return results
  end

  def others_parse(uploaded_file)
    # see public/examgen_demo.docx for example
    results = []
    # convert and split the converted string into seperate questions
    raw_strings = PandocRuby.convert(uploaded_file, '--from=docx', '--to=markdown', '--extract-media=tmp/')
                            .split("\\[Question\\]\n\n")
    # the first question also starts with [Question], so the fist element in raw_strings is empty
    raw_strings.delete_at(0)

    # raw_string #=> [Question]...[Choices]...[Answer]\n\nB\n\n[Topic]....
    raw_strings.each_with_index do |raw_string, index|
      # seperate images into different folder, one folder for one question
      # ![](... is markdown syntax of image
      move_images_into_sub_folders(raw_string, index) if %r{.*!\[]\(tmp.*}.match?(raw_string)

      splited_strings = raw_string.strip.split("\n\n\\[Answer\\]\n\n") # [0] #=> question, choices, [1] #=> answer, topic

      # Parse question
      # split question and choices
      question = splited_strings.first.split("\n\n\\[Choices\\]\n\n").first.split("\n\n")
      question.each { |line| line.gsub!(/\*\*/, '') unless line.include?('-------') } # remove bold markdown unless it's inside a table

      # Parse choices
      choices = splited_strings.first.split("\n\n\\[Choices\\]\n\n")[1].split("\n\n")
      alphabet = ('A'..'Z').to_a
      # escape '(' if needed
      choices.each_with_index do |choice, i|
        choices[i] = choice[0] == '(' ? "#{alphabet[i]}.  \\#{choice}" : "#{alphabet[i]}.  #{choice}"
      end

      answer = splited_strings[1][0]

      # the topic of topicless question is "Other"
      topic = if splited_strings[1].include?('Topic')
                splited_strings[1].split("\n\n\\[Topic\\]\n\n")[1].split("\n\n\\[Topic\\]\n\n").first
              else
                "Other"
              end

      results.push({ question: question, choices: choices, answer: answer, topic: topic })
    end
    return results
  end

  # when the docx is converted into markdown, it's just one long string and the images are saved in the same folder
  # so there is no structure that can determine which images belong to which question
  # this method put the extracted images into different folders
  # with each folder contains images from one question
  # these folders will be used to attach the images to the right question objects
  def move_images_into_sub_folders(raw_string, index)
    # create a folder for every questions that have images
    FileUtils.mkdir_p("tmp/media/#{index}")
    # scan("![](tmp").size finds how many images that question have from the markdown syntax
    raw_string.scan("![](tmp").size.times do
      # For question having n images, move the first n images in media/ to media/#{index}/
      first_image = Dir["tmp/media/*"].select { |path| path.include?("image") }.min # only select the files but not the folders
      FileUtils.mv first_image, "tmp/media/#{index}/#{first_image.gsub('tmp/media/', '')}"
    end
  end
end
