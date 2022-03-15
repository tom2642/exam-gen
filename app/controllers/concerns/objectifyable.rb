# frozen_string_literal: true

module Objectifyable
  def objectify_topic(result)
    # result[:topic] is a string
    topic = Topic.new(name: result[:topic])
    # save topic from docx into db or get topic object from db if that topic already exists in db
    # topic.valid would return false if that topic already exists in db
    topic.valid? ? topic.save! : topic = Topic.where(name: result[:topic]).first
    result[:topic] = topic # result[:topic] is now a Topic object
  end
end
