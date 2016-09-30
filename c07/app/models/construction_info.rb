class ConstructionInfo < ApplicationRecord
  validates :site_name, presence: true
  validates :construction_name, presence: true
  validates :enactment_location, presence: true
  validates :financial_year, numericality: { only_integer: true }
  validates :master_construction_probability_id, presence: true

  belongs_to :company
  belongs_to :customer_company, class_name: 'Company'
  belongs_to :master_construction_model
  belongs_to :master_construction_probability
  belongs_to :first_master_construction_probability, class_name: 'MasterConstructionProbability'
  belongs_to :master_bill_division
  belongs_to :quotation
  belongs_to :technical_employee, class_name: 'Employee'
  belongs_to :sales_employee,     class_name: 'Employee'
  belongs_to :foreman_employee,   class_name: 'Employee'

  before_create :hold_probability_on_create

  ransacker :id do
    Arel.sql("to_char(\"#{ table_name }\".\"id\", '#{ TO_CHAR_FORMAT }')")
  end

  def update_contract_probability!
    # 営業中工事の受注確率を100%に変更
    update!(master_construction_probability_id: Settings.construction_info.promote_to_construction_probability)
  end

  private

  def hold_probability_on_create
    # 登録時の受注確率を保持
    self[:first_master_construction_probability_id] = master_construction_probability_id
  end
end
