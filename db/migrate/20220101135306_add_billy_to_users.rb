class AddBillyToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :billy, :boolean, default: false
  end
end
