class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers, comment: '受注先情報' do |t|
      t.references :company_relation, comment: '会社情報'
      t.integer :category,          limit: 2, comment: 'カテゴリ'
      t.integer :cutoff_date,                 comment: '締日'
      t.integer :cutoff_date_cycle, limit: 2, comment: '締日サイクル'
      t.string  :arrival_day_of_submittal,    comment: '提出必着日'
      t.integer :receipt_date,                comment: '入金日'
      t.integer :receipt_account_code,        comment: '入金口座CD'
      t.integer :draft_site,                  comment: '手形サイト'
      t.boolean :receipt_account_code,        comment: '指定請求書'
      t.string  :receipt_term,                comment: '入金条件'

      t.integer  :created_by,                 comment: '作成者ID'
      t.integer  :updated_by,                 comment: '更新者ID'
      t.datetime :deleted_at,                 comment: '削除日時'
      t.timestamps
    end
  end
end
