class CreateCosts < ActiveRecord::Migration[5.0]
  def change
    create_table :costs, comment: '原価' do |t|
      t.references :company,          index: true, null: false, comment: '企業ID'
      t.references :account_heading, index: true,              comment: '勘定科目ID'
      t.integer    :code,         limit: 4,        null: false, comment: '原価コード'
      t.string     :name,                          null: false, comment: '原価名'
      t.integer    :cost_class,   limit: 2,        null: false, comment: '原価分類'
      t.integer    :budget_class, limit: 2,        null: false, comment: '予算分類'

      t.integer    :created_by, comment: '作成者ID'
      t.integer    :updated_by, comment: '更新者ID'
      t.datetime   :deleted_at, comment: '削除日時'
      t.timestamps null: false
    end

    add_index :costs, [:company_id, :code] # 論理削除レコードがある為、uniqueは貼らない
    add_index :costs, [:company_id, :cost_class]
    add_index :costs, [:company_id, :budget_class]
  end
end
