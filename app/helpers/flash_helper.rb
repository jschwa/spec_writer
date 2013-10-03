module FlashHelper

  def flash_alert_levels
    FLASH_CLASSES.keys
  end

  def flash_class level
    FLASH_CLASSES[level]
  end

  def flash_alert_message level
    Array.wrap(flash[level]).map { |msg| content_tag(:p, msg) }.join("").html_safe
  end

  private

  FLASH_CLASSES = {
    success: "alert-success",
    error: "alert-error",
    info: "alert-info",
    warning: "alert-warning",
    alert: "alert-error"
  }.freeze

end