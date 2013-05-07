class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :title
      t.text :front_end
      t.text :back_end
      t.integer :position
      t.integer :page_id

      t.timestamps
    end
  end
end
