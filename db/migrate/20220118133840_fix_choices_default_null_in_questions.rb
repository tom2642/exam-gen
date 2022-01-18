class FixChoicesDefaultNullInQuestions < ActiveRecord::Migration[6.1]
  def change
    change_column_default :questions, :choices, nil
    change_column_null :questions, :choices, true
  end
end
