User.all.map { |u| u.company.try(:id) }.compact.uniq.each do |company_id|
  ProfitDivision.seed(:company_id, :name,
    { company_id: company_id, name: '営業' },
    { company_id: company_id, name: 'ダクト工場' },
    { company_id: company_id, name: 'ダクト工事' },
    { company_id: company_id, name: '配管工場' },
    { company_id: company_id, name: '配管工事' },
    { company_id: company_id, name: '技術' },
    { company_id: company_id, name: '運送' },
    { company_id: company_id, name: '本社経費' },
    { company_id: company_id, name: '変動経費' },
  )
end
