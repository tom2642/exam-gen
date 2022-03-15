class Subject < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :topics, -> { distinct }, through: :questions

  validates :grade, :name, presence: true
  validates :grade, inclusion: { in: 1..15 }, numericality: { only_integer: true }
  # no duplicate subjects for a User
  validates :grade, uniqueness: { scope: %i[name user_id] }

  enum name: [
    :Biology, :'Business, Accounting and Financial Studies',
    :Chemistry, :Chinese, :'Chinese History', :'Chinese Literature', :'Combined Science',
    :'Design and Applied Technology',
    :Economics, :English, :'English Literature', :'Ethics and Religious Studies',
    :Geography,
    :'Health Management and Social Care', :History,
    :'Information and Communication Technology (ICT)', :'Integrated Science',
    :'Liberal Studies',
    :Mathematics, :'Mathematics Module 1', :'Mathematics Module 2', :Music,
    :'Physical Education', :Physics,
    :'Technology and Living', :'Tourism and Hospitality Studies',
    :'Visual Arts'
  ]
end
