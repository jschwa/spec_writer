class Page < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :features, order: "position desc"

  def reorder_features new_order
    features.each do |feature|
      new_position = features.size - 1 - new_order.index(feature.position.to_s)
      feature.update_attribute(:position, new_position)
    end
  end

end
