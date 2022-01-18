class RemoveScoreFromQuestions < ActiveRecord::Migration[6.1]
  def change
    remove_column :questions, :score, :integer
  end
end
