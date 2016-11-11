class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :title, null:false
      t.text :items, null:false
      t.text :description
      t.text :memo
      t.integer :owner_id, null:false

      t.timestamps null: false
    end
  end
end
