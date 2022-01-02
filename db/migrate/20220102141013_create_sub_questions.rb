class CreateSubQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :sub_questions do |t|
      t.text :question
      t.text :answer
      t.integer :sub_score

      t.timestamps
    end
  end
end
