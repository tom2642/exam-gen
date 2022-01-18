class AddTopicToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :topic, :string
  end
end
