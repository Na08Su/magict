class ControlTradingAccount < ApplicationRecord
  has_many   :regular_debit_accounts
  belongs_to :company

  validates :bank_code,         presence: true, exist_association: { key: :code, model: 'MasterBank' }
  validates :bank_branch_code,  presence: true, exist_association: { key: :code, model: 'MasterBankBranch' }
  validates :account_number,    presence: true
  validates :account_name,      presence: true
  validates :account_name_kana, presence: true
  validates :bank_short_name,   presence: true
  validates :account_headings,  presence: true
end
