class Cost < ApplicationRecord
  belongs_to :company
  belongs_to :account_heading

  validates :code, presence: true
  validates :name, presence: true
  validates :code, uniqueness_without_deleted: { scope: :company_id }
  validates :name, uniqueness_without_deleted: { scope: :company_id }

  enum cost_class: { cash: 1, cash_over_short: 2, current_deposit: 3 }
  enum budget_class: { class_a: 1, class_b: 2, class_c: 3, expense: 4 }

  acts_as_paranoid

  ransacker :code do
    Arel.sql("to_char(\"#{ table_name }\".\"code\", '#{ TO_CHAR_FORMAT }')")
  end

  class << self
    def import_by_csv(file)
      CsvImporter::MasterCostImporter.new(file: file).execute
    end
  end
end
