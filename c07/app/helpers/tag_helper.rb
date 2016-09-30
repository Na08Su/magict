module TagHelper
  def title_tag(resource:, i18n_key: nil)
    title_str = resource
    title_str = I18n.t((i18n_key || action_name), scope: :page_title, name: resource.model_name.human) if (resource.try(:ancestors) || []).include?(ApplicationRecord)

    content_tag(:h3, class: 'title') do
      concat title_str
      yield if block_given?
    end
  end

  # blockが渡された場合は、そのブロックの前後にスペースを入れる
  def spacer(width)
    if block_given?
      content_tag(:div, class: 'spacer', style: "margin: 0 #{ width }px;") do
        yield
      end
    else
      content_tag(:div, nil, class: 'spacer', style: "width:#{ width }px;")
    end
  end

  # @param [Hash] options
  # @option otpions [Symbol] :class
  # @option otpions [Symbol] :length
  def truncate_with_hint(str, options = {})
    return if str.blank?
    # 文字列の10文字以内に含まれる全角文字のカウントが5個以内の場合は、lengthを22に増やす
    applied_length = count_multi_byte(str[0..10]) < 5 ? 22 : 15
    options.reverse_merge!(class: 'hint--top', length: applied_length)
    content_tag(:span, class: options.delete(:class), data: { hint: str }) { truncate(str, options) }
  end

  def with_unit(str, unit_str, options = {})
    return if str.blank?
    options.reverse_merge!(unit_class: 'gray')

    out = []
    out << content_tag(:span, str)
    out << spacer(1)
    out << content_tag(:span, sanitize(unit_str), class: options[:unit_class])
    safe_join(out)
  end
end
