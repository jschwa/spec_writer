class Page < ActiveRecord::Base
  attr_accessible :name, :pt_info_attributes

  validates_presence_of :name

  has_many :items, order: "position desc", dependent: :destroy
  has_one :pt_info

  after_initialize :init_pt_info

  accepts_nested_attributes_for :pt_info

  def reorder_items new_order
    items.each do |a_item|
      new_position = items.size - 1 - new_order.index(a_item.position.to_s)
      a_item.update_attribute(:position, new_position)
    end
    touch
    fix_order
  end

  def fix_order
    actual_order = items.reload.collect(&:position)
    correct_order = (0..(items.size - 1)).to_a.reverse
    if actual_order != correct_order
      items.each_with_index do |a_item, index|
        a_item.update_attribute(:position, items.size - 1 - index)
      end
    end
  end

  def add_item new_item
    if items << new_item
      items.each do |a_item|
        if a_item != new_item && a_item.position >= new_item.position
          a_item.update_attribute(:position, a_item.position + 1)
        end
      end
      touch
      fix_order
      true
    else
      false
    end
  end

  def update_item item, item_params
    if item.update_attributes(item_params)
      touch
      true
    else
      false
    end
  end

  def destroy_item item
    index = items.to_a.index(item)
    (0..(index-1)).each do |i|
      items[i].decrease_position
    end
    items.delete item
    touch
    fix_order
  end

  def toggle_public
    update_attribute(:public, !public)
  end

  def highest? item
    item.position == items.count - 1
  end

  private

  def init_pt_info
    build_pt_info if pt_info.nil?
  end

end
