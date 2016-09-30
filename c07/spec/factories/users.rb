FactoryGirl.define do
  factory :user do
    uid                   { SecureRandom.hex(4) }
    provider              'provider'
    token                 { SecureRandom.uuid }
    email                 { Forgery(:internet).email_address }
    password              'password'
    password_confirmation 'password'
  end
end
