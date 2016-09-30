module ContractConstructionDecorator
  def schedule
    "#{ I18n.l(schedule_start, format: :default_ja) } - #{ I18n.l(schedule_end, format: :default_ja) }"
  end

  def budget_registration_link_str
    return '' unless budget_registrable?
    if budget.present?
      budget.total_amount.to_s(:delimited)
    else
      "#{ t('activerecord.models.budget') }#{ t('form.submit.create') }"
    end
  end
end
