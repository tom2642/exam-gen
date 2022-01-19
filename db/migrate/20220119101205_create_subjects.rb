class CreateSubjects < ActiveRecord::Migration[6.1]
  def change
    create_table :subjects do |t|
      t.integer :grade
      t.integer :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
