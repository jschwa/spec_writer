class Page < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :items, order: "position desc"

  def reorder_items new_order
    items.each do |a_item|
      new_position = items.size - 1 - new_order.index(a_item.position.to_s)
      a_item.update_attribute(:position, new_position)
    end
  end

end
