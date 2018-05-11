class AddTargetColumnToLikes < ActiveRecord::Migration[5.1]
  def change
    add_column :likes, :target_id, :integer
  end
end
