class SubQuestion < ApplicationRecord
  belongs_to :question

  validates :question, :answer, :sub_score, presence: true
  validates :sub_score, numericality: { in: 1..100 }
end
