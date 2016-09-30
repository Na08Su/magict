class Construction < ApplicationRecord
  belongs_to :site                       # 現場
  belongs_to :company_sub_classification # 工事区分
  has_one :joint_venture, through: :construction_joint_venture        # 共同体、サブコン1次請
  has_one :construction_joint_venture, -> { where(redeem_number: 1) } # redeem_number: 1は1次請けの番号
end
