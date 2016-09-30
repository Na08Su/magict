FactoryGirl.define do
  factory :control_trading_account do
    sequence(:id)
    sequence(:company_id)
    sequence(:bank_code)
    sequence(:bank_branch_code)
    sequence(:account_number)
    sequence(:account_name)      { |i| "AccountName#{ i }" }
    sequence(:account_name_kana) { |i| "NameKana#{ i }" }
    sequence(:bank_short_name)   { |i| "BankShortName#{ i }" }
    sequence(:account_headings)
    sequence(:limit_borrowing)
  end
end
