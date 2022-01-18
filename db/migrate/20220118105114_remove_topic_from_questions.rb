class RemoveTopicFromQuestions < ActiveRecord::Migration[6.1]
  def change
    remove_column :questions, :topic, :string
  end
end
