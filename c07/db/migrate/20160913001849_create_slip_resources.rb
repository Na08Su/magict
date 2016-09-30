class CreateSlipResources < ActiveRecord::Migration[5.0]
  def change
    create_table :slip_resources, comment: '資金' do |t|
      t.references :company,   null: false, comment: '企業ID'
      t.string     :code,      null: false, comment: '資金コード'
      t.string     :name,      null: false, comment: '名称'
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end
