Rails.configuration.stripe = {
  :publishable_key => 'pk_test_7UySrI7Uc62beTK6TOIhyvsF', # dashbordからapiキーをコピー
  :secret_key      => 'sk_test_WJWPxSsj07RtHMLa0Cm6ZIrO'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
