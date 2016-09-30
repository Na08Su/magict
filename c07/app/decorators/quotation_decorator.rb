module QuotationDecorator
  def attributes_for_modal
    {
      id: id,
      no: no,
      submitted_date: submitted_date.present? ? I18n.l(submitted_date) : nil,
      submitted_total_amount: submitted_total_amount.to_s(:delimited),
      initial_cost_total_amount: initial_cost_total_amount.to_s(:delimited)
    }
  end

  def submitted_total_amount
    quotation_details.to_a.sum { |d| d.submitted_amount.to_i }
  end

  def initial_cost_total_amount
    quotation_details.to_a.sum { |d| d.initial_cost_amount.to_i }
  end
end
