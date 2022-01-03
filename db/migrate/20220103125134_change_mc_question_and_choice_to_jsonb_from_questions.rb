class ChangeMcQuestionAndChoiceToJsonbFromQuestions < ActiveRecord::Migration[6.1]
  def change
    change_table :questions do |t|
      t.change :multiple_choice_question_or_short_question_text,
               :jsonb, null: false, default: '[]', using: 'multiple_choice_question_or_short_question_text::jsonb'
      t.change :choice, :jsonb, null: false, default: '[]', using: 'choice::jsonb'
    end
  end
end
