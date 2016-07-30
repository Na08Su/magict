# Rails.configuration.stripe = {
#   :publishable_key => 'pk_test_7UySrI7Uc62beTK6TOIhyvsF', # dashbordからapiキーをコピー
#   :secret_key      => 'sk_test_WJWPxSsj07RtHMLa0Cm6ZIrO'
# } ここに定義してしまうとセキュリティ的にまずいためgem 'figaro'を用いて、application.yml内にkeyを移動させる
Stripe.api_key = ENV['STRIPE_SECRET_KEY']
