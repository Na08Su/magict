class Business < ApplicationRecord
  belongs_to :company
  has_many :contract_constructions

  validates :code, presence: true
  validates :name, presence: true
  validates :financial_start_year, presence: true
  validates :code_number, presence: true
  validate  :already_used_code_number

  include Business::CodeNumberGenerator

  # 業務、または担当工事でcode_numberが使用されていた場合はエラーとする
  def already_used_code_number
    return true if code_number.blank?
    errors.add(:code_number, I18n.t('errors.messages.already_used', model: Business.model_name.human)) \
      if Business.where.not(id: id).exists?(company_id: company_id, financial_start_year: financial_start_year, code_number: code_number)
    errors.add(:code_number, I18n.t('errors.messages.already_used', model: ContractConstruction.model_name.human)) \
      if ContractConstruction.exists?(company_id: company_id, financial_year: financial_start_year, code: code_number)
  end
end
