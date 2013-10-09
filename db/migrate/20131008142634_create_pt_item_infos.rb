class CreatePtItemInfos < ActiveRecord::Migration
  def change
    create_table :pt_item_infos do |t|
      t.integer :item_id
      t.text :pt_json

      t.timestamps
    end
  end
end
