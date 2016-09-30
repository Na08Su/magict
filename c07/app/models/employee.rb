class Employee < ApplicationRecord
  belongs_to :user
  belongs_to :company

  scope :technical, -> { where(technical_flag: true) } # 技術担当者
  scope :sales,     -> { where(sales_flag: true) }     # 営業担当者
  scope :foreman,   -> { where(foreman_flag: true) }   # 工事担当者(責任者)
end
