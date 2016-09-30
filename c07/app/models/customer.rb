class Customer < ApplicationRecord
  belongs_to :company_relation

  enum category: { authorities: 0, general_contractor: 1, subcontractor: 2, contractor: 3, special: 4, other: 9 }, _prefix: true
  enum cutoff_date_cycle: { present_month: 0, next_month: 1, month_after_next: 2, unknown: 9 }, _prefix: true
end
