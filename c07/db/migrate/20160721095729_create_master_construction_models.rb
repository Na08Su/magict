class CreateMasterConstructionModels < ActiveRecord::Migration[5.0]
  def change
    create_table :master_construction_models, comment: '受注形態マスタ' do |t|
      t.string   :name,        null: false,                 comment: '受注形態名称'
      t.string   :name_short,                               comment: '受注形態名称略称(帳票用)'
      t.integer  :code_order,  null: false,                 comment: '並び順'
      t.boolean  :bundle_flag, null: false, default: false, comment: '一括フラグ'

      t.integer  :created_by,                               comment: '作成者ID'
      t.integer  :updated_by,                               comment: '更新者ID'
      t.datetime :deleted_at,                               comment: '削除日時'
      t.timestamps
    end
  end
end
