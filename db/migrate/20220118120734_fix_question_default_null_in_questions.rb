class FixQuestionDefaultNullInQuestions < ActiveRecord::Migration[6.1]
  def change
    change_column_default :questions, :question, nil
    change_column_null :questions, :question, true
  end
end
