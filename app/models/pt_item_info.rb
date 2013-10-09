class PtItemInfo < ActiveRecord::Base
  attr_accessible :item_id, :pt_json


  def story_id
    JSON.parse(pt_json)["id"]
  end

end
