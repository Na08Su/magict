class MasterBankBranch < ApplicationRecord
  validates :code,      presence: true, uniqueness: { scope: :master_bank_code }
  validates :name,      presence: true
  validates :name_kana, presence: true

  belongs_to :master_bank, class_name: 'MasterBank', foreign_key: :master_bank_code
end
