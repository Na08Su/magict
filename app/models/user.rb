class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  validates :name, presence: true, length: { maximum: 25 }
  
  has_many :subscriptions #subscriptionとは....課金的な意味合い?
  has_many :projects, through: :subscriptions
  has_many :reviews
  has_many :requests
  # after_create :send_notification

  # def send_notification
  #   Mymailer.new_user(self).deliver #後でメールのクラスに合わせて修正する, new_userもmailerの中のメソッド
  # end

  def self.find_for_facebook_oauth(access_token, signed_in_resource = nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid).first

    if user
      return user
    else
      registered_user = User.where(:email => data.email).first
      if registered_user
        return registered_user
      else
        user = User.create(
          name: access_token.extra.raw_info.name,
          provider: access_token.provider,
          email: data.email,
          uid: access_token.uid,
          image: data.image,
          password: Devise.friendly_token[0, 20],
          )
      end
    end
  end

  def self.find_for_github_oauth(access_token, signed_in_resource = nil)
    data = access_token['info']
    user = User.where(:provider => access_token['provider'], :uid => access_token['uid']).first

    if user
      return user
    else
      registered_user = User.where(:email => data['email']).first
      if registered_user
        return registered_user
      else

        if data['name'].nil?
          name = data['nickname']
        else
          name = data['name']
        end

        user = User.create(
          name: name,
          provider: access_token['provider'],
          email: data['email'],
          uid: access_token['uid'],
          image: data['image'],
          password: Devise.friendly_token[0, 20],
          )
      end
    end
  end
end
