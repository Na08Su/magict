FactoryGirl.define do
  factory :employee do
    association :user, factory: :user
    association :company, factory: :company
    firstname { Forgery('name').first_name }
    lastname  { Forgery('name').last_name }
  end
end
