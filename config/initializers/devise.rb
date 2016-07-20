
Devise.setup do |config|

  config.mailer_sender = 'natsuki @ luxiar <noreply@example.com>'

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10

  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete

  require 'omniauth-facebook'
  config.omniauth :facebook, '312561132466456', '4e32c5eeef907a7a65606a66fd908515'

  require 'omniauth-github'
  config.omniauth :github, 'dabe88cda37b5be7c2b4', 'bcaa3ef4a7c2df92e23330721493a9d6a95c26aa', scope: 'user:email'

end
