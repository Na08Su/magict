class Prefecture < ApplicationRecord
  has_many :company
  has_many :main_sites
end
