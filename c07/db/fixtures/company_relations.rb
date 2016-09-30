company_ids = Employee.pluck(:company_id).uniq.compact
company_ids.each do |company_id|
  company_relations = Company.where.not(id: company_id).pluck(:id).sample(100).map do |partner_company_id|
    { own_company_id: company_id, partner_company_id: partner_company_id, code: format('%06d', rand(1..999999)), own_company_code: format('%06d', rand(1..999999)),
      customer_flag: rand(2), payee_flag: rand(2), vendor_flag: rand(2) }
  end

  CompanyRelation.seed(:own_company_id, :partner_company_id, company_relations)
end

CompanyRelation.all.map do |company_relation|
  Customer.seed({ company_relation_id: company_relation.id })
  Vendor.seed({ company_relation_id: company_relation.id })
  Payee.seed({ company_relation_id: company_relation.id })
end
