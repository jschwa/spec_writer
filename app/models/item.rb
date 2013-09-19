class Item < ActiveRecord::Base

  ITEMIZABLE_TYPES = ["Feature", "Divider"]

  attr_accessible :page_id, :position, :itemizable, :itemizable_attributes, :itemizable_type

  belongs_to :itemizable, polymorphic: true, dependent: :destroy
  accepts_nested_attributes_for :itemizable

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

end