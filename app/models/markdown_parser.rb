class MarkdownParser

  TAB = "     "

  def initialize markdown
    @markdown = markdown
  end

  def to_html
    @markdown = @markdown.gsub(/\r\n#{TAB}\*/, "\r\n#{TAB}**")
    RedCloth.new(@markdown).to_html
  end

end