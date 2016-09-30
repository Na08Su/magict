class MasterBank < ApplicationRecord
  self.primary_key = :code

  validates :code,      presence: true, uniqueness: true
  validates :name,      presence: true, uniqueness: true
  validates :name_kana, presence: true, uniqueness: true

  has_many :master_bank_branches, foreign_key: :master_bank_code, dependent: :destroy
end
