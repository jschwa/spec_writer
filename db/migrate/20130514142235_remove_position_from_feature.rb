class RemovePositionFromFeature < ActiveRecord::Migration
  def up
    remove_column :features, :position
    remove_column :features, :page_id
  end

  def down
    add_column :features, :position, :integer
    add_column :features, :page_id, :integer
  end
end
