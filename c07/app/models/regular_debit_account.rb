class RegularDebitAccount < ApplicationRecord
  belongs_to :control_trading_account

  validates :drawer_type,                presence: true
  validates :withdrawal_month,           presence: true
  validates :withdrawal_day,             presence: true
  validates :payment_content,            presence: true
  validates :payment_amount,             presence: true
  validates :control_trading_account_id, presence: true

  enum drawer_type: { fixation: 1, remotion: 2, fluctuation: 3 }
  enum withdrawal_month: { monthly: 0, january: 1, february: 2, march: 3, april: 4, may: 5, june: 6, july: 7, august: 8, september: 9, october: 10, november: 11, december: 12 }

  scope :fixation,    -> { where(drawer_type: 'fixation') }
  scope :remotion,    -> { where(drawer_type: 'remotion') }
  scope :fluctuation, -> { where(drawer_type: 'fluctuation') }

  acts_as_paranoid
end
