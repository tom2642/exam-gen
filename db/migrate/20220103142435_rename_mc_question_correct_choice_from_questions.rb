class RenameMcQuestionCorrectChoiceFromQuestions < ActiveRecord::Migration[6.1]
  def change
    change_table :questions do |t|
      t.rename :multiple_choice_question_or_short_question_text, :question
      t.rename :correct_choice, :answer
    end
  end
end
