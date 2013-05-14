class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :page_id
      t.integer :itemizable_id
      t.string  :itemizable_type
      t.integer :position
      t.timestamps
    end
  end
end
