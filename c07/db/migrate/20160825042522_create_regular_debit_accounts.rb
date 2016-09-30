class CreateRegularDebitAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :regular_debit_accounts, comment: '定例引落管理' do |t|
      t.references :company,                 null: false, comment: '企業ID'
      t.references :control_trading_account, null: false, comment: '取引先口座ID'
      t.integer    :drawer_type,             null: false, comment: '引落タイプ'
      t.integer    :withdrawal_month,        null: false, comment: '引落月'
      t.string     :withdrawal_day,          null: false, comment: '引落日'
      t.string     :payment_content,         null: false, comment: '支払い内容'
      t.string     :payment_content_detail,               comment: '詳細'
      t.string     :payment_amount,          null: false, comment: '支払い金額'
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end
