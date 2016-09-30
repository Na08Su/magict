class Vendor < ApplicationRecord
  belongs_to :company_relation
  belongs_to :payee # 支払先、グループ会社の場合、仕入先が支店で支払先が本社とかの場合がある
  belongs_to :account_heading

  enum category: { material: 1, out_sourcing: 2, expenses: 3, other: 4 }, _prefix: true
end
