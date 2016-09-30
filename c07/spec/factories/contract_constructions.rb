FactoryGirl.define do
  factory :contract_construction do
    financial_year  1
    name            { Forgery('address').city }
    sequence(:code) { |i| format('%05d', i) }

    after(:build) do |c|
      c.company  ||= create(:company)
      c.business ||= create(:business, company: c.company)
    end
  end
end
