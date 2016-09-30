company_ids = Employee.pluck(:company_id).uniq.compact
company_ids.each do |company_id|
  Quotation.seed(:no, :company_id,
    { company_id: company_id, no: '32-001', name: '見積001', submitted_date: '2016/08/01' }, 
    { company_id: company_id, no: '32-002', name: '見積002', submitted_date: '2016/08/02' }, 
    { company_id: company_id, no: '32-003', name: '見積003', submitted_date: '2016/08/03' }, 
    { company_id: company_id, no: '32-004', name: '見積004', submitted_date: '2016/08/04' }, 
    { company_id: company_id, no: '32-005', name: '見積005', submitted_date: '2016/08/05' }, 
    { company_id: company_id, no: '32-006', name: '見積006', submitted_date: '2016/08/06' }, 
    { company_id: company_id, no: '32-007', name: '見積007', submitted_date: '2016/08/07' }, 
    { company_id: company_id, no: '32-008', name: '見積008', submitted_date: '2016/08/08' }, 
    { company_id: company_id, no: '32-009', name: '見積009', submitted_date: '2016/08/09' }, 
    { company_id: company_id, no: '32-010', name: '見積010', submitted_date: '2016/08/10' }, 
    { company_id: company_id, no: '32-011', name: '見積011', submitted_date: '2016/08/11' }, 
  )
end

quotation_details = Quotation.all.map do |quotation|
  costs = Cost.all.sample(rand(1..20)).map.with_index(1) do |cost, index|
    { quotation_id: quotation.id, cost_id: cost.id, row_number: index, name1: cost.name,
      submitted_quantity: rand(1..10), submitted_price: rand(100..100000), initial_cost_quantity: rand(1..10), initial_cost_price: rand(100..100000) }
  end
end.flatten

QuotationDetail.seed(:quotation_id, :cost_id, *quotation_details)
