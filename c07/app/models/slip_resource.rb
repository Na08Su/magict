class SlipResource < ApplicationRecord
  belongs_to :company

  validates :company_id, presence: true
  validates :code,       presence: true, uniqueness: { scope: :company_id }
  validates :name,       presence: true, uniqueness: { scope: :company_id }

  acts_as_paranoid
end
