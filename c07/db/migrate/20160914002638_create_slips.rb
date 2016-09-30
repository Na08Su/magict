class CreateSlips < ActiveRecord::Migration[5.0]
  def change
    create_table :slips, comment: '伝票' do |t|
      t.references :company,        null: false, comment: '企業ID'
      t.string     :code,           null: false, comment: '伝票番号'
      t.integer    :financial_year, null: false, comment: '決算期'
      t.references :slip_type,     null: false,  comment: '伝票分類'
      t.date       :slip_date,      null: false, comment: '伝票日付'
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end
