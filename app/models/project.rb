class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :tasks
  has_many :subscriptions
  has_many :users, through: :subscriptions
  has_many :reviews

  validates :name,    presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 250 }
  validates :price,   presence: true, numericality: { only_integer: true }

  has_attached_file :image,
                    storage: s3,
                    s3_permissions: public,
                    s3_credentials: "#{ Rails.root }/config/s3.yml",
                    path: ":attachment/:id/:style.:extension",
                    styles: { medium: "680x300>", thumb: "170x75>" } # peperclip
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/ # paperclip

  def shortname #project#indexで使っている
    name.length > 25? name[0..25] + "..." : name
  end

  def average_rating
    reviews.blank? ? 0 : reviews.average(:star).round(2)
  end

  def price_in_cents #日本の円にするなら必要ない
    price*100
  end
end
