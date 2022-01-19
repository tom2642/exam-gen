class Question < ApplicationRecord
  belongs_to :subjects
  has_many_attached :images

  validates :question, :answer,
            presence: true
end
