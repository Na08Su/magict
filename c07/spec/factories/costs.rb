FactoryGirl.define do
  factory :cost do
    association :company, factory: :company
    sequence(:code)
    sequence(:name) { |i| "CostName#{ i }" }
    cost_class      { Cost.cost_classes.values.sample }
    budget_class    { Cost.budget_classes.values.sample }
  end
end
