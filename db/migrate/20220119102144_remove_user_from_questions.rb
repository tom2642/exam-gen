class RemoveUserFromQuestions < ActiveRecord::Migration[6.1]
  def change
    remove_reference :questions, :user, null: false, foreign_key: true
  end
end
