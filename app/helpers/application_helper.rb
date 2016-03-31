module ApplicationHelper
  def li_link_to(name, url, options = {})
    options[:class] ||= ""
    options[:class] << " nav-link"
    content_tag(:li, class: 'nav-item') do
      link_to(name, url, options)
    end
  end
end
