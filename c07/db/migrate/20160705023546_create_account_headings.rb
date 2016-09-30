class CreateAccountHeadings < ActiveRecord::Migration[5.0]
  def change
    create_table :account_headings, comment: '勘定科目' do |t|
      t.references :company, index: true, null: false, comment: '企業ID'
      t.string     :code,                 null: false, comment: 'コード'
      t.string     :name,                 null: false, comment: '名称'
      t.integer    :division, limit:2,    null: false, comment: '区分'

      t.integer    :created_by, comment: '作成者ID'
      t.integer    :updated_by, comment: '更新者ID'
      t.datetime   :deleted_at, comment: '削除日時'
      t.timestamps
    end

    add_index :account_headings, [:company_id, :code] # 論理削除レコードがある為、uniqueは貼らない
    add_index :account_headings, [:company_id, :division]
  end
end
