class ContractConstruction < ApplicationRecord
  belongs_to :company
  belongs_to :business
  belongs_to :construction_info
  belongs_to :quotation
  belongs_to :technical_employee, class_name: 'Employee'
  belongs_to :sales_employee,     class_name: 'Employee'
  belongs_to :foreman_employee,   class_name: 'Employee'

  has_one :budget

  validates :company_id, presence: true
  validates :business_id, presence: true
  validates :financial_year, presence: true
  validates :code, presence: true, uniqueness: { scope: :financial_year }
  validates :decision_no, uniqueness: true

  enum construction_division: { main_work: 1, add_work: 2, general_work: 3, other: 4 }, _prefix: true
  enum contract_division: { general_contractor: 1, sub_contractor: 2, general: 3,
                            direct_sales: 4, direct_publicity: 5, direct_trader: 6, government_office: 7, other: 8 }, _prefix: true
  enum order_status: { decision_order: 1, decision_amount: 2, payment_certainty: 3, completion: 4 }, _prefix: true
  enum progress: { default: 0, budget_decision: 20, closed: 99 }, _prefix: true

  before_create :generate_decision_no

  delegate :customer_company, to: :construction_info

  # TODO: スタータスを持たせるのであれば、そちらを参照すべき
  def budget_registrable?
    decision_no.present? && decision_amount.present?
  end

  private

  def generate_decision_no
    self[:decision_no] = "#{ financial_year }-#{ format('%03d', company.contract_constructions.count + 1) }"
  end
end
