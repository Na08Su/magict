class CreateControlTradingAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :control_trading_accounts, comment: '取引先口座' do |t|
      t.references :company,           null: false, comment: '企業ID'
      t.string     :bank_code,         null: false, comment: '銀行コード'
      t.string     :bank_branch_code,  null: false, comment: '支店コード'
      t.string     :account_number,    null: false, comment: '口座番号'
      t.string     :account_name,      null: false, comment: '口座名義'
      t.string     :account_name_kana, null: false, comment: '口座名義カナ'
      t.string     :bank_short_name,   null: false, comment: '銀行名略称'
      t.string     :account_headings,  null: false, comment: '勘定科目'
      t.string     :limit_borrowing,                comment: '借入限度額'

      t.timestamps
    end
  end
end
