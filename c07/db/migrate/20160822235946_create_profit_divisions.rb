class CreateProfitDivisions < ActiveRecord::Migration[5.0]
  def change
    create_table :profit_divisions, comment: '採算区分' do |t|
      t.references :company, null: false, index: true, comment: '企業ID'
      t.string     :name,    null: false,              comment: '名称'

      t.integer    :created_by,                        comment: '作成者'
      t.integer    :updated_by,                        comment: '更新者'
      t.datetime   :deleted_at,                        comment: '削除日時'
      t.timestamps
    end
  end
end
