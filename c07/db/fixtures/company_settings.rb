company_ids = Employee.pluck(:company_id).uniq.compact
company_ids.each do |company_id|
  CompanySetting.seed(
    company_id: company_id, financial_year: 32, closing_first_year: 1985, closing_start_month: 3, consumption_tax: 0.08
  )
end
