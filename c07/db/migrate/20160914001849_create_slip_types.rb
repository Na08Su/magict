class CreateSlipTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :slip_types, comment: '伝票分類' do |t|
      t.references :company,      null: false, comment: '企業ID'
      t.string     :code,         null: false, comment: '伝票分類コード'
      t.string     :name,         null: false, comment: '名称'
      t.integer    :order_number, null: false, comment: '順番'
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end
