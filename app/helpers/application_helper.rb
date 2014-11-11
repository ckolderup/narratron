module ApplicationHelper
  def apple_touch_icon(size)
    link = ''
    link << '<link rel=\"apple-touch-icon\" '
    link << "sizes=\"#{xbyx(size)}\"" if size.present?
    link << "href=\"/images/apple-touch-icon"
    link << "-#{xbyx(size)}" if size.present?
    link << ".png\" />"
    link.html_safe
  end

  def xbyx(x)
    "#{x}x#{x}"
  end
end
