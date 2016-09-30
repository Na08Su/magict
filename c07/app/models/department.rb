class Department < ApplicationRecord
  belongs_to :division

  validates :code, presence: true, uniqueness: { scope: :division_id }
  validates :name, presence: true, uniqueness: { scope: :division_id }

  acts_as_paranoid
end
