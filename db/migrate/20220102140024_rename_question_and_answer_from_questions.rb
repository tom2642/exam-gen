class RenameQuestionAndAnswerFromQuestions < ActiveRecord::Migration[6.1]
  def change
    change_table :questions do |t|
      t.rename :question, :multiple_choice_question_or_short_question_text
      t.rename :answer, :correct_choice
    end
  end
end
