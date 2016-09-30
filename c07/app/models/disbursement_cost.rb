class DisbursementCost < ApplicationRecord
  belongs_to :company
  # costはnil OK
  belongs_to :cost

  validates :company_id, presence: true
  validates :name,       presence: true, uniqueness: { scope: :company_id }

  acts_as_paranoid
end
