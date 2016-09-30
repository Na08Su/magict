class SlipDetail < ApplicationRecord
  belongs_to :slip
  belongs_to :slip_resource, -> { with_deleted }
  belongs_to :division, -> { with_deleted }
  belongs_to :contract_construction
  belongs_to :cost, -> { with_deleted }
  belongs_to :debit_account_heading, -> { with_deleted }, class_name: 'AccountHeading'
  belongs_to :credit_account_heading, -> { with_deleted }, class_name: 'AccountHeading'

  validates :debit_account_heading_id, presence: true
  validates :credit_account_heading_id, presence: true
  validates :amount, presence: true

  acts_as_paranoid
end
