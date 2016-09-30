User.all.map { |u| u.company.try(:id) }.compact.uniq.each do |company_id|
  SlipType.seed(:company_id, :code, :name,
    { company_id: company_id, code: '1' , name: '【売上】'     , order_number: 1 },
    { company_id: company_id, code: '2' , name: '【資材】'     , order_number: 2 },
    { company_id: company_id, code: '3' , name: '【外注】'     , order_number: 3 },
    { company_id: company_id, code: '4' , name: '【経費】'     , order_number: 4 },
    { company_id: company_id, code: '5' , name: '【事業部売上】', order_number: 5 },
    { company_id: company_id, code: '6' , name: '【一般管理費】', order_number: 6 },
    { company_id: company_id, code: '7' , name: '【仮払金】'   , order_number: 7 },
    { company_id: company_id, code: '8' , name: '【出金】'     , order_number: 8 },
    { company_id: company_id, code: '9' , name: '【その他】'   , order_number: 11 },
    { company_id: company_id, code: '10', name: '【完成工事高】', order_number: 12 },
    { company_id: company_id, code: '11', name: '【完成原価】'  , order_number: 13 },
    # ホーセック用
    #{ company_id: company_id, code: '12', name: '【振込】'     , order_number: 9 , deleted_at: '2016/03/17' },
    #{ company_id: company_id, code: '13', name: '【振替】'     , order_number: 10, deleted_at: '2016/03/17' },
  )
end
