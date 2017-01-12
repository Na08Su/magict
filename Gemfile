source 'https://rubygems.org'

gem 'rails', '4.2.4'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'

gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'materialize-sass'
gem 'devise'
gem 'ransack' # 検索
gem 'toastr-rails'
gem 'omniauth'


gem 'omniauth-facebook'
gem 'omniauth-github' #task4

gem 'activeadmin', github: 'activeadmin' # task5
gem 'active_skin'

gem 'paperclip', '~> 5.0'
gem 'redcarpet', '~> 3.3', '>= 3.3.4'
gem 'coderay', '~> 1.1'

gem 'friendly_id', '~> 5.1'
gem 'active_admin-sortable_tree', '~> 0.2.1'
gem 'stripe'
gem 'figaro', '~> 1.1', '>= 1.1.1' # HerokuやDokkuで使う環境変数を管理するGem「laserlemon/figaro」の紹介です。 モダンなWebアプリケーションの設計の指針とも言える「Twelve-Factor App」を実現するのを手助けしてくれる素晴らしいGemです。
gem 'fog' # AWS S3」へ画像アップロード連携ができるようにするために使います。
gem 'aws-sdk', '~> 2.3' # AWS



group :development, :test do
  gem 'byebug'
  gem 'rubocop'
end

group :development do
  gem 'sqlite3'
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

