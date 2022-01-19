class RemoveGradeFromQuestions < ActiveRecord::Migration[6.1]
  def change
    remove_column :questions, :grade, :integer
  end
end
