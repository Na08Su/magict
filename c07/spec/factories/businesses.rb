FactoryGirl.define do
  factory :business do
    association :company, factory: :company
    sequence(:name)        { |i| "Business_#{ i }" }
    financial_start_year   1
    profit_division_id     1
    sequence(:code_number) { |i| format('%05d', i) }
  end
end
