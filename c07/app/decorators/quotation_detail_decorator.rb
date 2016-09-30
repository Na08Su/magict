module QuotationDetailDecorator
  def submitted_amount
    return nil if submitted_quantity.nil? || submitted_price.nil?
    submitted_quantity * submitted_price
  end

  def initial_cost_amount
    return nil if initial_cost_quantity.nil? || initial_cost_price.nil?
    initial_cost_quantity * initial_cost_price
  end
end
