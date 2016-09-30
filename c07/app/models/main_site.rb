class MainSite < ApplicationRecord
  belongs_to :prefecture, foreign_key: :prefecture_code
  has_many :sites
end
