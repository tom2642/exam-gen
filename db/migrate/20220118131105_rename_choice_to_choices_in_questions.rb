class RenameChoiceToChoicesInQuestions < ActiveRecord::Migration[6.1]
  def change
    rename_column :questions, :choice, :choices
  end
end
