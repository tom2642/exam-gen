class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.text :question
      t.string :choice
      t.text :answer
      t.integer :score
      t.integer :grade
      t.integer :subject
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
