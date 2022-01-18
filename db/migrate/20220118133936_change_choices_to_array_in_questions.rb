class ChangeChoicesToArrayInQuestions < ActiveRecord::Migration[6.1]
  def change
    change_column :questions, :choices, :string, array: true, default: [], using: 'choices::character varying[]'
  end
end
