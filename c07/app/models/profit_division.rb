class ProfitDivision < ApplicationRecord
  belongs_to :company

  validates :company_id, presence: true
  validates :name, presence: true
end
