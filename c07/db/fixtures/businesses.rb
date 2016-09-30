company_ids = Employee.pluck(:company_id).uniq.compact
company_ids.each do |company_id|
  Business.seed(:company_id, :code,
    { company_id: company_id, code: '32-1-00100', name: '業務001', financial_start_year: 32, profit_division_id: 1, code_number: '00100' }, 
    { company_id: company_id, code: '32-2-00200', name: '業務002', financial_start_year: 32, profit_division_id: 2, code_number: '00200' }, 
    { company_id: company_id, code: '32-1-00300', name: '業務003', financial_start_year: 32, profit_division_id: 1, code_number: '00300' }, 
    { company_id: company_id, code: '32-3-00400', name: '業務004', financial_start_year: 32, profit_division_id: 3, code_number: '00400' }, 
    { company_id: company_id, code: '32-1-00500', name: '業務005', financial_start_year: 32, profit_division_id: 1, code_number: '00500' }, 
    { company_id: company_id, code: '32-4-00600', name: '業務006', financial_start_year: 32, profit_division_id: 4, code_number: '00600' }, 
    { company_id: company_id, code: '32-1-00700', name: '業務007', financial_start_year: 32, profit_division_id: 1, code_number: '00700' }, 
    { company_id: company_id, code: '32-5-00800', name: '業務008', financial_start_year: 32, profit_division_id: 5, code_number: '00800' }, 
    { company_id: company_id, code: '32-1-00900', name: '業務009', financial_start_year: 32, profit_division_id: 1, code_number: '00900' }, 
    { company_id: company_id, code: '32-6-01000', name: '業務010', financial_start_year: 32, profit_division_id: 6, code_number: '01000' }, 
    { company_id: company_id, code: '32-1-01100', name: '業務011', financial_start_year: 32, profit_division_id: 1, code_number: '01100' }, 
  )
end

