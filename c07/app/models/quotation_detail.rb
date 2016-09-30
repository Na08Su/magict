class QuotationDetail < ApplicationRecord
  belongs_to :quotation
  belongs_to :cost, -> { with_deleted }

  # NOTE: 一旦全ての検証を外すが、区分等を選択させる場合には追加する
  validates :row_number, presence: true, numericality: { only_integer: true }
  validates :name1,      presence: true
end
