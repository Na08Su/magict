class Site < ApplicationRecord
  belongs_to :main_site
  has_many :constructions
end
