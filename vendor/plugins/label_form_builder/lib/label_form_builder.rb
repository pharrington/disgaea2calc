class LabelFormBuilder < ActionView::Helpers::FormBuilder
  helpers = field_helpers + ['select'] - %w[hidden_field label fields_for]

  helpers.each do |name|
    define_method(name) do |text, field, *args|
      label_class = args.last.delete(:label_class) if args.last.is_a?(::Hash)
      label_id = args.last.delete(:label_id) if args.last.is_a?(::Hash)
      label_class = label_class ? " class='#{label_class}'" : ''
      label_id = label_id ? " id='#{label_id}'" : ''
      "<label#{label_id}#{label_class}>\n#{text}\n#{super(field, *args)}\n</label>"
    end
  end
end
