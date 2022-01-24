class ChangeQuestionToArrayInQuestions < ActiveRecord::Migration[6.1]
  def change
    change_column :questions, :question, :string, array: true, default: [], using: 'question::character varying[]'
  end
end
