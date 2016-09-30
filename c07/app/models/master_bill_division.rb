class MasterBillDivision < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  include MasterDataCacheable
end
