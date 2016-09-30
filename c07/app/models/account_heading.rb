class AccountHeading < ApplicationRecord
  belongs_to :company
  has_many   :costs

  validates :code, presence: true
  validates :name, presence: true
  validates :code, uniqueness_without_deleted: { scope: :company_id }
  validates :name, uniqueness_without_deleted: { scope: :company_id }
  validates :division, presence: true

  enum division: { resource: 1, debt: 2, capital: 3, sales: 4, expense: 5, profit: 6, etc: 7 }

  acts_as_paranoid
end
