class Question < ApplicationRecord
  belongs_to :subject
  belongs_to :topic, optional: true
  has_many_attached :images

  validates :question, :answer, presence: true
  # no duplicate questions
  validates :question, uniqueness: { scope: %i[choices answer topic_id subject_id] }
end
