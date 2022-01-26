# frozen_string_literal: true

module ImagesAttachable
  def attach_images(question, index)
    # "tmp/media/#{index}" is created in Parseable::docx_to_md
    unless Dir["tmp/media/#{index}"].empty? # unless the question doesn't have a image
      # for all the images inside the folder of their quesiton, attach imagen.jpg as #{question.id}_n.jpg to question
      Dir["tmp/media/#{index}/*"].sort.each do |fname|
        question.images.attach(io: File.open(fname), filename: fname.gsub(%r{tmp/media/./image}, "#{question.id}_"))
      end
    end

    # change the markdown in question that indicates the path of its images
    question.question.each do |line|
      # later when generating docx, the images from active record are saved in tmp/media/ first
      line.gsub!(%r{!\[]\(tmp//media/image}, "![](tmp//media/#{question.id}_")
    end
    question.save!
  end
end
