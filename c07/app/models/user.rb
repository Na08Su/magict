class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable if ENV['USE_DOORKEEPER_AUTHENTICATION']

  has_one :employee
  delegate :company, to: :employee, allow_nil: true

  class << self
    def find_or_create_with_oauth(oauth_data)
      if (user = User.find_by(uid: oauth_data.uid, provider: oauth_data.provider))
        user[:token] = oauth_data.credentials.token
        return user
      end

      create(
        uid:      oauth_data.uid,
        provider: oauth_data.provider,
        token:    oauth_data.credentials.token,
        email:    oauth_data.info.email,
        password: Devise.friendly_token[0, 20]
      )
    end
  end
end
