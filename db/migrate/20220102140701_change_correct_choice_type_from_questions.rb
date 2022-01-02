class ChangeCorrectChoiceTypeFromQuestions < ActiveRecord::Migration[6.1]
  def change
    change_column :questions, :correct_choice, :string
  end
end
