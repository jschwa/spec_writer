class Feature < ActiveRecord::Base
  attr_accessible :back_end, :front_end, :position, :title

  validates_presence_of :back_end, :front_end, :title
end
