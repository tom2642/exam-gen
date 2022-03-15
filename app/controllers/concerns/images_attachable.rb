# frozen_string_literal: true

module ImagesAttachable
  def attach_images(question, index)
    # "tmp/media/#{index}" is created in Parseable::docx_to_md
    unless Dir["tmp/media/#{index}"].empty? # unless the question doesn't have a image
      # for all the images inside the folder of their quesiton, attach imagen.jpg as #{question.id}_n.jpg to question
      Dir["tmp/media/#{index}/*"].sort.each do |fname|
        question.images.attach(io: File.open(fname), filename: fname.gsub(%r{tmp.*/}, ''))
      end
    end

    # replace local image path in markdown with cloudinary url
    question.images.each do |image|
      question.question.each do |line|
        line.gsub!(%r{!\[\]\(.*\)}, "![](#{image.url})") if line.include?(image.filename.to_s)
      end
    end
    question.save!
  end
end
