class CreatePtInfos < ActiveRecord::Migration
  def change
    create_table :pt_infos do |t|
      t.string :api_key
      t.string :project_name
      t.boolean :separate_front_end_from_back_end, default: false
      t.integer :page_id

      t.timestamps
    end
  end
end
