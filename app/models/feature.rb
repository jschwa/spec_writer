class Feature < ActiveRecord::Base
  DEFAULT_VALUE = "_User Story_\r\n\r\n\r\n_Logic_\r\n\r\n\r\n_Acceptance Criteria_\r\n"

  attr_accessible :back_end, :front_end, :title

  validate :at_least_one_filed_defined
  after_initialize :set_default_values, if: :new_record?
  before_validation :check_default_values

  def set_default_values
    self.back_end = DEFAULT_VALUE if back_end.blank?
    self.front_end = DEFAULT_VALUE if front_end.blank?
  end

  private

  def at_least_one_filed_defined
    if title.blank? && front_end.blank? && back_end.blank?
      [:title, :front_end, :back_end].each do |field|
        errors.add(field, "at least one of title, front end and back end should be definded")
      end
    end
  end

  def check_default_values
    if back_end == DEFAULT_VALUE
      self.back_end = ""
    end
    if front_end == DEFAULT_VALUE
      self.front_end = ""
    end
  end

end
