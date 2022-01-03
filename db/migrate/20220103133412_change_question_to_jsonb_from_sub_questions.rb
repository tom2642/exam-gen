class ChangeQuestionToJsonbFromSubQuestions < ActiveRecord::Migration[6.1]
  def change
    change_column :sub_questions, :question, :jsonb, null: false, default: '[]', using: 'question::jsonb'
  end
end
