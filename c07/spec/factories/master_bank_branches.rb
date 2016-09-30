FactoryGirl.define do
  factory :master_bank_branch, class: MasterBankBranch do
    master_bank { create(:master_bank) }
    sequence(:id)
    sequence(:code)
    sequence(:name)      { |i| "MasterBankBranchName#{ i }" }
    sequence(:name_kana) { |i| "MasterBankBranchNameKana#{ i }" }
  end
end
