module ApplicationHelper
  def apple_touch_icon_tag(size)
    link = ''
    link << '<link rel="apple-touch-icon" '
    link << "sizes=\"#{xbyx(size)}\"" if size.present?
    link << "href=\"#{apple_touch_icon_path(size)}\" />"
    link.html_safe
  end

  def apple_touch_icon_path(size)
    filename = "apple-touch-icon"
    filename << "-#{xbyx(size)}" if size.present?
    filename << ".png"
    image_path(filename)
  end

  def xbyx(x)
    "#{x}x#{x}"
  end
end
