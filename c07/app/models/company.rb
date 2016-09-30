class Company < ApplicationRecord
  belongs_to :prefecture, foreign_key: :prefecture_code

  has_many :employees
  has_many :own_company_relations,     foreign_key: :own_company_id,     class_name: 'CompanyRelation' # 自社の登録したパートナー企業の情報
  has_many :partner_company_relations, foreign_key: :partner_company_id, class_name: 'CompanyRelation' # 自社をパートナーとしている企業群
  has_many :control_trading_accounts
  has_many :account_headings, dependent: :delete_all
  has_many :costs, dependent: :delete_all
  has_many :profit_divisions, dependent: :delete_all
  has_many :businesses, dependent: :delete_all
  has_many :quotations, dependent: :delete_all
  has_many :construction_infos, dependent: :delete_all
  has_many :contract_constructions, dependent: :delete_all
  has_many :control_trading_accounts
  has_many :regular_debit_accounts
  has_one  :company_setting, dependent: :destroy
  has_many :slip_resources, dependent: :delete_all
  has_many :slip_types, dependent: :delete_all
  has_many :divisions, dependent: :delete_all
  has_many :slips, dependent: :delete_all
  has_many :disbursement_costs, dependent: :delete_all

  def customer_companies
    own_company_relations.customers.includes(:partner_company).map(&:partner_company)
  end
end
