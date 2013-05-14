class Item < ActiveRecord::Base
  attr_accessible :page_id, :position, :itemizable, :itemizable_attributes, :itemizable_type



  belongs_to :itemizable, polymorphic: true
  accepts_nested_attributes_for :itemizable

end
