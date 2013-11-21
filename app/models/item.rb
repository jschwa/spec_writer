class Item < ActiveRecord::Base

  ITEMIZABLE_TYPES = ["Feature", "Divider"]

  attr_accessible :page_id, :position, :itemizable, :itemizable_attributes, :itemizable_type

  belongs_to :itemizable, polymorphic: true, dependent: :destroy
  accepts_nested_attributes_for :itemizable
  has_many :pt_item_infos, dependent: :destroy
  belongs_to :page

  def decrease_position
    update_attribute(:position, position - 1)
  end

  def set_default_values
    itemizable.set_default_values
  end

  def build_itemizable(params, assignment_options)
    raise "Unknown client_type: #{itemizable_type}" unless ITEMIZABLE_TYPES.include?(itemizable_type)
    self.itemizable = itemizable_type.constantize.new(params)
  end

  def feature?
    itemizable_type == "Feature"
  end

  def add_pt_item_info(json)
    pt_item_infos << PtItemInfo.new(pt_json: json)
  end

  def update_pt_item_info(json)
    pt_item_info_to_update = pt_item_infos.find { |item_info| item_info.same_story_id?(json) }
    pt_item_info_to_update.update_attribute(:pt_json, json)
  end

end

