User.all.map { |u| u.company.try(:id) }.compact.uniq.each do |company_id|
  SlipResource.seed(:company_id, :code, :name,
    { company_id: company_id, code: '101', name: '現金売上' },
    { company_id: company_id, code: '102', name: '完成未収入金　回収' },
    { company_id: company_id, code: '103', name: '未成工事受入金　回収' },
    { company_id: company_id, code: '104', name: '受取手形期日入金' },
    { company_id: company_id, code: '105', name: '利息収入' },
    { company_id: company_id, code: '106', name: 'その他　経常収入' },
    { company_id: company_id, code: '109', name: '資産・有証券売却金' },
    { company_id: company_id, code: '110', name: '仮払・立替　返済等' },
    { company_id: company_id, code: '111', name: '短期借入金' },
    { company_id: company_id, code: '112', name: '長期借入金' },
    { company_id: company_id, code: '113', name: '手形割引' },
    { company_id: company_id, code: '114', name: '定期・積立　解約' },
    { company_id: company_id, code: '115', name: '貸付金　回収' },
    { company_id: company_id, code: '116', name: 'その他　財務収入' },
    { company_id: company_id, code: '001', name: '現金仕入' },
    { company_id: company_id, code: '002', name: '未成工事支出金' },
    { company_id: company_id, code: '003', name: '工事・未払金　支払' },
    { company_id: company_id, code: '004', name: '支払手形決済' },
    { company_id: company_id, code: '005', name: '一般管理費　支払' },
    { company_id: company_id, code: '006', name: '借入利息　支払' },
    { company_id: company_id, code: '007', name: '割引料　支払' },
    { company_id: company_id, code: '008', name: 'その他　経常支出' },
    { company_id: company_id, code: '009', name: '法人税等税金　支払' },
    { company_id: company_id, code: '010', name: '資産・有証券購入金' },
    { company_id: company_id, code: '011', name: '利息処分金' },
    { company_id: company_id, code: '012', name: '仮払金等' },
    { company_id: company_id, code: '013', name: '短期借入金　返済' },
    { company_id: company_id, code: '014', name: '長期借入金　返済' },
    { company_id: company_id, code: '015', name: '定期・積立　振込' },
    { company_id: company_id, code: '016', name: 'その他　財務支出' },
  )
end
