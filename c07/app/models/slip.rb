class Slip < ApplicationRecord
  belongs_to :company
  belongs_to :slip_type
  has_many :slip_details, dependent: :delete_all

  validates :company_id, presence: true
  validates :financial_year, presence: true
  validates :slip_type, presence: true
  validates :slip_date, presence: true
  validate :slip_details_should_be_exist, on: [:create, :update]

  acts_as_paranoid

  accepts_nested_attributes_for :slip_details, allow_destroy: true

  def auto_numbering(number)
    self.code = format('%06d', number)
  end

  private

  def slip_details_should_be_exist
    errors.add(:slip_details, 'は１件以上登録してください') if slip_details.size <= 0
  end
end
