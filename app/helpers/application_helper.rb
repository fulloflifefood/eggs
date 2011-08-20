# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
   def title(page_title)
     content_for(:title) { page_title }
   end


  def render_error_messages(*objects)
    messages = objects.compact.map {|o| o.errors.full_messages}.flatten
    render :partial => 'error_messages', :object => messages unless messages.empty?
  end

  def format_date(date, use_time = false)
    if use_time
      ampm = date.strftime("%p").downcase
      date.strftime("%B %d, %Y at %I:%M" + ampm)
    else
      date.strftime("%B %d, %Y")
    end
  end


end
