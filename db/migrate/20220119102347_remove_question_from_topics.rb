class RemoveQuestionFromTopics < ActiveRecord::Migration[6.1]
  def change
    remove_reference :topics, :question, null: false, foreign_key: true
  end
end
