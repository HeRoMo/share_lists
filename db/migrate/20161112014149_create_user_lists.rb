class CreateUserLists < ActiveRecord::Migration
  def change
    create_table :user_lists do |t|
      t.integer :user_id, null:false
      t.integer :list_id, null:false
      t.integer :rating, default: 0

      t.timestamps null: false
    end
    add_index :user_lists,[:user_id,:list_id], :unique => true
  end
end
