class CompanySetting < ApplicationRecord
  belongs_to :company

  validates :financial_year,      presence: true, numericality: { only_integer: true }
  validates :closing_first_year,  presence: true, numericality: { only_integer: true }
  validates :closing_start_month, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :consumption_tax,     presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
