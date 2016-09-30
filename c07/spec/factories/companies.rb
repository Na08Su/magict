FactoryGirl.define do
  factory :company do
    name { Forgery('name').company_name }
  end
end
