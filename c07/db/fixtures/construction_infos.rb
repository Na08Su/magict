company_ids = Employee.pluck(:company_id).uniq.compact
company_ids.each do |company_id|
  company = Company.find(company_id)
  customer_ids = company.customer_companies.map(&:id)

  ConstructionInfo.seed(:company_id, :site_name, :construction_name,
    { company_id: company_id, site_name: 'Kent Plaza　新築工事', construction_name: '衛生設備工事', enactment_location: '滋賀県草津市', financial_year: 32,
      master_construction_model_id: 1, master_construction_probability_id: 5, customer_company_id: nil, schedule_start: '2008/12/01', schedule_end: '2009/10/01',
      enactment_schedule_start: '2008/12/01', enactment_schedule_end: '2009/10/01', technical_employee_id: nil, sales_employee_id: nil, foreman_employee_id: nil,
      building_contractor: '建築業者', expected_amount: 2000000, quotation_id: 1, master_bill_division_id: 1, recital: '備考だよ', customer_company_id: customer_ids.sample },
    { company_id: company_id, site_name: '京都大学(北部)総合研究所(地球惑星科学系)　改修工事', construction_name: 'ダクト工事', enactment_location: '京都府京都市', financial_year: 32,
      master_construction_model_id: 1, master_construction_probability_id: 5, customer_company_id: nil, schedule_start: '2008/11/28', schedule_end: '2009/03/01',
      enactment_schedule_start: '2008/11/28', enactment_schedule_end: '2009/03/01', technical_employee_id: nil, sales_employee_id: nil, foreman_employee_id: nil,
      building_contractor: '建築業者2', expected_amount: 3500000, quotation_id: 2, master_bill_division_id: 2, recital: '', customer_company_id: customer_ids.sample },
    { company_id: company_id, site_name: '大山崎中学校新校舎建設工事', construction_name: 'ダクト工事', enactment_location: '京都府乙訓郡', financial_year: 32,
      master_construction_model_id: 10, master_construction_probability_id: 5, customer_company_id: nil, schedule_start: '2008/10/01', schedule_end: '2009/10/10',
      enactment_schedule_start: '2008/10/01', enactment_schedule_end: '2009/12/10', technical_employee_id: nil, sales_employee_id: nil, foreman_employee_id: nil,
      building_contractor: "建築業者3", expected_amount: 5000000, quotation_id: 3, master_bill_division_id: 3, recital: '備考ですぞ！！', customer_company_id: customer_ids.sample }
  )
end
