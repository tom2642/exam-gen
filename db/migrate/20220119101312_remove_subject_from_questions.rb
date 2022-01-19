class RemoveSubjectFromQuestions < ActiveRecord::Migration[6.1]
  def change
    remove_column :questions, :subject, :integer
  end
end
