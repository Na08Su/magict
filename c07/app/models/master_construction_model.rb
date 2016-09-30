class MasterConstructionModel < ApplicationRecord
  validates :name,       presence: true, uniqueness: true
  validates :name_short, presence: true
  validates :code_order, presence: true, numericality: { only_integer: true }, uniqueness: true

  include MasterDataCacheable
end
