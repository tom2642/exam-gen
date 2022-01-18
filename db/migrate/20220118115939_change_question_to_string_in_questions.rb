class ChangeQuestionToStringInQuestions < ActiveRecord::Migration[6.1]
  def change
    change_column :questions, :question, :string
  end
end
