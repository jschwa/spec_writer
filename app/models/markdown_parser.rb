class MarkdownParser

  TAB = "     "

  def initialize markdown
    @markdown = markdown
  end

  def to_html
    @markdown = @markdown.gsub(/\r\n#{TAB}\*/, "\r\n**")
    @markdown = @markdown.gsub(/\r\n#{TAB}#{TAB}\*/, "\r\n***")
    RedCloth.new(@markdown).to_html
  end

end