class CreateCompanyRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :company_relations, comment: '取引先情報' do |t|
      t.references :partner_company, null: false, comment: '相手の会社'
      t.references :own_company,     null: false, comment: '自分の会社'
      t.string  :code,               null: false, comment: '取引先CD'
      t.string  :own_company_code,   null: false, comment: '取引先側で管理している自社のCD'
      t.string  :contact_person,                  comment: '窓口担当者'
      t.string  :contact_tel,                     comment: '窓口担当tel'
      t.string  :contact_fax,                     comment: '窓口担当fax'
      t.date    :basic_contract_day,              comment: '基本契約締結日'
      t.date    :start_up_date,                   comment: '取引開始日'
      t.string  :recital1,                        comment: '備考1'
      t.string  :recital2,                        comment: '備考2'
      t.boolean :customer_flag, default: false,   comment: '受注先として使うか'
      t.boolean :payee_flag,    default: false,   comment: '支払先として使うか'
      t.boolean :vendor_flag,   default: false,   comment: '仕入先として使うか'

      t.integer  :created_by,                     comment: '作成者ID'
      t.integer  :updated_by,                     comment: '更新者ID'
      t.datetime :deleted_at,                     comment: '削除日時'
      t.timestamps
    end

    add_index :company_relations, [:own_company_id, :partner_company_id], unique: true, name: 'index_company_relations_on_own_and_partner_company_id'
    add_index :company_relations, [:own_company_id, :code], unique: true
    add_index :company_relations, [:own_company_id, :customer_flag]
    add_index :company_relations, [:own_company_id, :payee_flag]
    add_index :company_relations, [:own_company_id, :vendor_flag]
  end
end
