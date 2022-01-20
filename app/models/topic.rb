class Topic < ApplicationRecord
  has_many :questions

  validates :name, presence: true, uniqueness: true
end
