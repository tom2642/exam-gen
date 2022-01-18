class Question < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  validates :question, :answer, :grade, :subject,
            presence: true
  validates :grade, numericality: { in: 1..15 }

  enum subject: [
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
