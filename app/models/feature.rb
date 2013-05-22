class Feature < ActiveRecord::Base
  attr_accessible :back_end, :front_end, :title

  validate :at_least_one_filed_defined

  private

  def at_least_one_filed_defined
    if title.blank? && front_end.blank? && back_end.blank?
      [:title, :front_end, :back_end].each do |field|
        errors.add(field, "at least one of title, front end and back end should be definded")
      end
    end
  end

end
