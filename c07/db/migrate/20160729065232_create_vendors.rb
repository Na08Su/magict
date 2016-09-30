class CreateVendors < ActiveRecord::Migration[5.0]
  def change
    create_table :vendors, comment: '仕入先情報' do |t|
      t.references :company_relation, comment: '会社情報'
      # vendor_type
      t.integer :category, limit: 2, comment: '種別'
      t.references :payee,           comment: '支払先'
      t.references :account_heading, comment: '未払時勘定科目'

      t.integer  :created_by,        comment: '作成者ID'
      t.integer  :updated_by,        comment: '更新者ID'
      t.datetime :deleted_at,        comment: '削除日時'
      t.timestamps
    end
  end
end
