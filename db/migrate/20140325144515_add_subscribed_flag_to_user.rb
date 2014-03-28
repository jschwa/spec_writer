class AddSubscribedFlagToUser < ActiveRecord::Migration
  def change
    add_column :users, :plan, :string, default: "free"
  end
end
