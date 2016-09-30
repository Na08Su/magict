FactoryGirl.define do
  factory :account_heading do
    association :company, factory: :company
    sequence(:code)
    sequence(:name) { |i| "AccountHeading#{ i }" }
    division        { AccountHeading.divisions.values.sample }
  end
end
