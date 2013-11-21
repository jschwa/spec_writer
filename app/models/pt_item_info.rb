class PtItemInfo < ActiveRecord::Base
  attr_accessible :item_id, :pt_json


  def story_id
    JSON.parse(pt_json)["id"]
  end

  def same_story_id? json
    json = JSON.parse(json) unless json.is_a?(Hash)
    story_id == json["id"]
  end

end
