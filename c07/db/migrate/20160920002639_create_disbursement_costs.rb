class CreateDisbursementCosts < ActiveRecord::Migration[5.0]
  def change
    create_table :disbursement_costs, comment: '出金伝票用支払内容' do |t|
      t.references :company,        null: false, comment: '企業ID'
      t.string     :name,           null: false, comment: '支払内容'
      t.integer    :cost_id,                     comment: '原価ID'
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end
