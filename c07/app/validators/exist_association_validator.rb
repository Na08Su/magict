class ExistAssociationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    model = options[:model].safe_constantize
    record.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.messages.record_invalid')) unless model.find_by(options[:key] => value)
  end
end
