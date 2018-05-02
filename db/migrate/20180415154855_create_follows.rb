class CreateFollows < ActiveRecord::Migration[5.1]
  def change
    create_table :follows do |t|
      t.integer :target_id, index: true
      t.integer :user_id, index: true

      t.timestamps null: false
    end

    add_index :follows, %i[target_id user_id], unique: true
  end
end
