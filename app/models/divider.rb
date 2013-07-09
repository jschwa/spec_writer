class Divider < ActiveRecord::Base
  attr_accessible :title

  validates_presence_of :title

  def set_default_values

  end
end