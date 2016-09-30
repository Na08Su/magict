class SlipType < ApplicationRecord
  belongs_to :company
  has_many :slips

  validates :company_id,   presence: true
  validates :code,         presence: true
  validates :name,         presence: true
  validates :order_number, presence: true

  acts_as_paranoid
end
