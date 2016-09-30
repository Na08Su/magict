class CreateSlipDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :slip_details, comment: '伝票詳細' do |t|
      t.references :slip,        null: false,    comment: '伝票ID'
      t.references :slip_resource,               comment: '資金ID'
      t.references :division,                    comment: '部門'
      t.references :contract_construction,       comment: '担当工事ID'
      t.references :cost,                        comment: '原価ID'
      t.integer    :debit_account_heading_id,    comment: '借方勘定科目ID'
      t.integer    :credit_account_heading_id,   comment: '貸方勘定科目ID'
      t.integer    :row_number,                  comment: '行番号'
      t.string     :summary,                     comment: '摘要'
      t.string     :summary_item,                comment: '摘要(品目)'
      t.date       :summary_date,                comment: '摘要(日付)'
      t.column     :amount,    'bigint',         comment: '金額'
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end
