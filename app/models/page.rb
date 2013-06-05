class Page < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name

  has_many :items, order: "position desc", dependent: :destroy

  def reorder_items new_order
    items.each do |a_item|
      new_position = items.size - 1 - new_order.index(a_item.position.to_s)
      a_item.update_attribute(:position, new_position)
    end
  end

  def destroy_item item
    index = items.to_a.index(item)
    (0..(index-1)).each do |i|
      items[i].decrease_position
    end
    items.delete item
  end

  def toggle_public
    update_attribute(:public, !public)
  end

end
