# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Generating Users..."
users = User.create!(
  [
    { email: 'billy@billy.com', password: 'billy123', billy: true },
    { email: 'a@a.com', password: '123123' }
  ]
)

puts "Generating Subjects..."
user0_subjects = users[0].subjects.create!(
  [
    { grade: 11, name: "Economics" },
    { grade: 12, name: "Economics" }
  ]
)
user1_subjects = users[1].subjects.create!(
  [
    { grade: 5, name: "English" },
    { grade: 2, name: "Visual Arts" }
  ]
)

puts "Generating Topics..."
topics = Topic.create!(
  [
    { name: "What" },
    { name: "Test" }
  ]
)

puts "Generating Questions..."
q0 = user0_subjects[0].questions.new(
  question: "Due to a good harvest of Boston lobsters (波士頓龍蝦), the quantity\ntransacted of Boston lobsters increases while the price decreases. Which\nof the following are correct?\n\n    \\(1) The quantity demanded of Boston lobsters increases.\n\n    \\(2) The demand for Boston lobsters increases.\n\n    \\(3) The quantity transacted of Japanese lobsters decreases.\n\n    \\(4) The demand for Japanese lobsters decreases.\n\n",
  choices: ["A.  \\(1) and (4) only", "B.  \\(2) and (3) only", "C.  \\(1), (3) and (4) only", "D.  \\(2), (3) and (4) only"],
  answer: "C"
)
q0.topic = topics[0]
q0.save!
puts "Q1 done"

q1 = user1_subjects[0].questions.new(
  question: "Faithful Department Store launches a gift redemption scheme to celebrate\nits 10^th^ anniversary: a customer who spends over \\$200 can receive a\nstamp and the number of stamps required to redeem various types of gift\nare shown below:\n\n      **Number of stamps required**   **Gifts**\n  ------------------------------- ----------------------\n  10                              A pack of chopsticks\n  50                              A teapot\n  100                             A wok\n\n    What is the cost of redeeming a teapot with 50 stamps?\n\n",
  choices: ["A.  A pack of chopsticks", "B.  0.5 wok", "C.  5 packs of chopsticks", "D.  None of the above"],
  answer: "C"
)
q1.topic = topics[1]
q1.save!
puts "Q2 done"
