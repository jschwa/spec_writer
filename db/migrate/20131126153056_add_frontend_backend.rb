class AddFrontendBackend < ActiveRecord::Migration
 def change
   add_column :pt_item_infos, :frontend_or_backend, :string
 end

end
