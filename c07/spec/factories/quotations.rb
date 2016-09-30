FactoryGirl.define do
  factory :quotation do
    sequence(:no)   { |i| "00-#{ format('%03d', i) }" }
    sequence(:name) { |i| "見積#{ format('%03d', i) }" }
    submitted_date  { Time.zone.today }

    after(:build) do |q|
      rand(10).times do |i|
        q.quotation_details << build(:quotation_detail, row_number: (i + 1))
      end
    end
  end
end
