# frozen_string_literal: true

module Objectifyable
  def objectify_topic(result)
    # result[:topic] is a string
    topic = Topic.new(name: result[:topic])
    # save topic from docx to topics table or get from table if already exists
    topic.valid? ? topic.save! : topic = Topic.where(name: result[:topic]).first
    result[:topic] = topic # result[:topic] is now a Topic object/reference
  end
end
