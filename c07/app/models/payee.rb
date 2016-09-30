class Payee < ApplicationRecord
  belongs_to :company_relation
  has_many :vendors
end
