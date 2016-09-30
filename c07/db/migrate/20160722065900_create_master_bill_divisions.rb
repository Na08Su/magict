class CreateMasterBillDivisions < ActiveRecord::Migration[5.0]
  def change
    create_table :master_bill_divisions, comment: '請求区分マスタ' do |t|
      t.string :name, null: false, comment: '請求区分名称'

      t.integer  :created_by,      comment: '作成者ID'
      t.integer  :updated_by,      comment: '更新者ID'
      t.datetime :deleted_at,      comment: '削除日時'
      t.timestamps
    end
  end
end
