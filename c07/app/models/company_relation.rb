class CompanyRelation < ApplicationRecord
  belongs_to :partner_company, foreign_key: :partner_company_id, class_name: 'Company'
  belongs_to :own_company, foreign_key: :own_company_id, class_name: 'Company'

  has_one :customer, dependent: :destroy
  has_one :payee, dependent: :destroy
  has_one :vendor, dependent: :destroy

  validates :code, presence: true, uniqueness: { scope: :own_company_id }
  validates :partner_company_id, presence: true, uniqueness: { scope: :own_company_id }
  validates :own_company_id, presence: true

  accepts_nested_attributes_for :customer, allow_destroy: true
  accepts_nested_attributes_for :payee, allow_destroy: true
  accepts_nested_attributes_for :vendor, allow_destroy: true
  accepts_nested_attributes_for :partner_company

  scope :customers, -> { where(customer_flag: true) }
  scope :payees, -> { where(payee_flag: true) }
  scope :vendors, -> { where(vendor_flag: true) }

  def customer?
    customer_flag
  end

  def payee?
    payee_flag
  end

  def vendor?
    vendor_flag
  end
end
