FactoryGirl.define do
  factory :quotation_detail do
    sequence(:name1)      { |i| "name1_#{ i }" }
    sequence(:name2)      { |i| "name2_#{ i }" }
    submitted_quantity    { rand(1..10) }
    submitted_price       { rand(100000) }
    initial_cost_quantity { rand(1..10) }
    initial_cost_price    { rand(100000) }
  end
end
