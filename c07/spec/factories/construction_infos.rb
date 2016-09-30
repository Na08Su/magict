FactoryGirl.define do
  factory :construction_info do
    association :company, factory: :company
    sequence(:site_name)          { |i| "現場名_#{ i }" }
    sequence(:construction_name)  { |i| "工事名_#{ i }" }
    sequence(:enactment_location) { |i| "施工場所_#{ i }" }
    financial_year                1
    master_construction_probability_id 5
  end
end
