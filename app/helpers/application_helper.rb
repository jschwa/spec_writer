module ApplicationHelper

  def textile_to_html textile
    red_cloth = RedCloth.new(textile)
    red_cloth.hard_breaks = false
    red_cloth.to_html.html_safe
  end

end
