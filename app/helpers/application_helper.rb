module ApplicationHelper
  def flash_class(message_type)
    case message_type.to_sym
    when :notice
      'bg-green-100 border border-green-400 text-green-700'
    when :alert
      'bg-red-100 border border-red-400 text-red-700'
    when :info
      'bg-blue-100 border border-blue-400 text-blue-700'
    else
      'bg-gray-100 border border-gray-400 text-gray-700'
    end
  end

  def flash_icon_color(message_type)
    case message_type.to_sym
    when :notice
      'text-green-500'
    when :alert
      'text-red-500'
    when :info
      'text-blue-500'
    else
      'text-gray-500'
    end
  end

  def page_title(title = '')
    base_title = 'GIFT QUEST APP'
    title.present? ? "#{title} | #{base_title}" : base_title
  end
end
