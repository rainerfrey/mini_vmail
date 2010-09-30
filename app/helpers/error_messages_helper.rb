module ErrorMessagesHelper
  # Render error messages for the given objects. The :message and :header_message options are allowed.
  def error_messages_for(*objects)
    options = objects.extract_options! 
    messages = objects.compact.map { |o| o.errors.full_messages }.flatten
    unless messages.empty?
      object = objects[0]
      model = if object.class.respond_to?(:model_name)
         object.class.model_name.human
      else
        object.class.to_s.humanize
      end
      options[:header_message] ||= t(:'activerecord.errors.template.header', :count => messages.count, :model => model)
      options[:message] ||= t(:'activerecord.errors.template.body')
      content_tag(:div, :id => "error_messages") do
        list_items = messages.map { |msg| content_tag(:li, msg) }
        content_tag(:h2, options[:header_message]) + content_tag(:p, options[:message]) + content_tag(:ul, list_items.join.html_safe)
      end
    end
  end
  
  module FormBuilderAdditions
    def error_messages(options = {})
      @template.error_messages_for(@object, options)
    end
  end
end

ActionView::Helpers::FormBuilder.send(:include, ErrorMessagesHelper::FormBuilderAdditions)
