# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

billy = User.create!(
  email: 'billy@billy.com',
  password: 'billy123',
  password_confirmation: 'billy123',
  billy: true
)

billy.questions.create!(
  [
    {
      question: ['Which of the following factors will affect the demand for Samsung smartphones?',
                 '(1)	A change in people’s income',
                 '(2)	A change in the price of iPhones',
                 '(3)	A change in the price of Samsung smartphones',
                 '(4)	A change in the production cost of smartphones'],
      choice: ['A.	(1) and (2) only',
               'B.	(2) and (3) only',
               'C.	(3) and (4) only',
               'D.	(1), (2), (3) and (4)'],
      answer: 'A',
      score: 1,
      grade: 12,
      subject: :Economics
    },
    {
      question: ['Suppose the demand curve for a tour package to Korea is downward sloping. ' \
                 'Which of the following CANNOT be constant when we move from one point to another on the demand curve?'],
      choice: ['A.	The price of the tour package to Korea',
               'B.	The price of a tour package to Japan',
               'C.	People’s income',
               'D.	The price of a travel guidebook to Korea'],
      answer: 'A',
      score: 1,
      grade: 12,
      subject: :Economics
    },
    {
      question: ['After changing to a better paid job, Josie eats spaghetti more frequently but pizza less frequently. To Josie,',
                 '(1)	spaghetti is a normal good.',
                 '(2)	pizza is an inferior good.',
                 '(3)	spaghetti and pizza are substitutes.'],
      choice: ['A.	(1) and (2) only',
               'B.	(1) and (3) only',
               'C.	(2) and (3) only',
               'D.	(1), (2) and (3)'],
      answer: 'A',
      score: 1,
      grade: 12,
      subject: :Economics
    }
  ]
)
