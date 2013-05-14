class CreateDividers < ActiveRecord::Migration
  def change
    create_table :dividers do |t|
      t.string :title
      t.timestamps
    end
  end
end
