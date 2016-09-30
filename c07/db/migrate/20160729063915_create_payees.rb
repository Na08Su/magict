class CreatePayees < ActiveRecord::Migration[5.0]
  def change
    create_table :payees, comment: '支払先情報' do |t|
      t.references :company_relation, comment: '会社情報'
      t.integer :cutoff_date, comment: '締日'
      t.integer :payment_account, comment: '支払情報-振込'
      t.integer :payment_check, comment: '支払情報-小切手'
      t.integer :payment_cash, comment: '支払情報-現金'
      t.integer :payment_note_payable, comment: '支払情報-支払手形'
      t.integer :draft_site, comment: '手形サイト'
      # 現状使われていないようなので退避
      #t.integer :cash_collect, comment: '現金集金'
      #t.integer :draft_collect, comment: '手形集金'
      t.integer :payment_notice, comment: '支払通知'
      #t.integer :payment_special, comment: '支払特別'
      t.references :master_bank_branch, comment: '銀行-支店'
      t.integer :bank_account_type, comment: '口座種別'
      t.string :bank_account_number, comment: '口座番号'
      t.string :bank_account_name, comment: '口座名義'
      t.string :bank_account_name_kana, comment: '口座名義カナ'

      t.integer  :created_by,      comment: '作成者ID'
      t.integer  :updated_by,      comment: '更新者ID'
      t.datetime :deleted_at,      comment: '削除日時'
      t.timestamps
    end
  end
end
