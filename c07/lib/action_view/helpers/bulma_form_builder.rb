module ActionView
  module Helpers
    # BulmaCssをinputやselectに当てていくのが面倒なので、カスタムFormBuilderを作る
    # usage.
    #   = form_for @construction_info, builder: ActionView::Helpers::BulmaFormBuilder do |f|
    class BulmaFormBuilder < FormBuilder
      include ::NestedForm::BuilderMixin

      def text_field(method, options = {})
        class_options = options[:class].try(:split, ' ') || []
        class_options += ['input', 'is-small']
        options[:class] = class_options.uniq.compact.join(' ')
        @template.text_field(@object_name, method, options)
      end

      # @option otpions [Symbol] :label_suffix ラベルの後ろに入れたい文字(スペース等)
      # usage.
      #  = label_with_select(:hoge, Hoge.all, { label_suffix: spacer(5) { ':' } }
      def label_with_text_field(method, options = {})
        label_suffix = options.delete(:label_suffix) || ''
        label(method) + label_suffix + text_field(method, options)
      end

      def select(method, choices = nil, options = {}, html_options = {}, &block)
        class_options = html_options.delete(:class).try(:split, ' ') || []
        class_options += ['select', 'is-small']
        html_options[:class] = 'w100'
        @template.content_tag(:span, class: class_options.uniq.compact.join(' ')) do
          @template.select(@object_name, method, choices, objectify_options(options), @default_options.merge(html_options), &block)
        end
      end

      # See. label_with_text usage.
      def label_with_select(method, choices = nil, options = {}, html_options = {}, &block)
        label_suffix = options.delete(:label_suffix) || ''
        label(method) + label_suffix + select(method, choices, options, html_options, &block)
      end

      def comma_delimited_field(method, options = {})
        class_options = options[:class].try(:split, ' ') || []
        class_options << 'text-right'
        options[:class] = class_options.uniq.compact.join(' ')
        options = options.merge(data: { autonumeric: { mDec: 0 } }) unless options.dig(:data, :autonumeric, :mDec)
        text_field(method, options)
      end
    end
  end
end
