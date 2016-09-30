class CreateBudgets < ActiveRecord::Migration[5.0]
  def change
    create_table :budgets, comment: '実行予算' do |t|
      t.references :contract_construction, null: false, index: true, comment: '担当工事ID'
      t.string     :no,                    null: false,              comment: '予算NO'
      t.integer    :status, limit: 2,      null: false, default: 0,  comment: 'ステータス'

      t.integer    :created_by,                                      comment: '作成者'
      t.integer    :updated_by,                                      comment: '更新者'
      t.datetime   :deleted_at,                                      comment: '削除日時'
      t.timestamps
    end
  end
end
