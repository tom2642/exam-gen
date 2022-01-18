class ChangeChoicesToStringInQuestions < ActiveRecord::Migration[6.1]
  def change
    change_column :questions, :choices, :string
  end
end
