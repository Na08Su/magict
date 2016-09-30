FactoryGirl.define do
  factory :master_bank do
    sequence(:id)
    sequence(:code)
    sequence(:name)      { |i| "MasterBankName#{ i }" }
    sequence(:name_kana) { |i| "MasterBankNameKana#{ i }" }
  end
end
