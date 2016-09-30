User.all.map { |u| u.company.try(:id) }.compact.uniq.each do |company_id|
  Division.seed(:company_id, :code, :name,
    { company_id: company_id, code: '001' , name: '本社総合' },
    { company_id: company_id, code: '100' , name: '本社経費' },
    { company_id: company_id, code: '200' , name: '技術' },
    { company_id: company_id, code: '300' , name: '配管工事' },
    { company_id: company_id, code: '400' , name: '配管工場' },
    { company_id: company_id, code: '500' , name: 'ダクト工事' },
    { company_id: company_id, code: '600' , name: 'ダクト工場' },
    { company_id: company_id, code: '700' , name: '運送' },
    { company_id: company_id, code: '800' , name: '営業' },
    { company_id: company_id, code: '900' , name: '協力業者' },
    { company_id: company_id, code: '999' , name: '変動経費' },
  )
end
