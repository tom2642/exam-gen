class AddTopicReferencesToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :topic, foreign_key: true, null: true
  end
end
