class Division < ApplicationRecord
  belongs_to :company
  has_many   :departments

  validates :company_id, presence: true
  validates :code, presence: true
  validates :name, presence: true

  acts_as_paranoid
end
