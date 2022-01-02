class AddQuestionToSubQuestions < ActiveRecord::Migration[6.1]
  def change
    add_reference :sub_questions, :question, null: false, foreign_key: true
  end
end
