class CreateDivisions < ActiveRecord::Migration[5.0]
  def change
    create_table :divisions, comment: '部門' do |t|
      t.references :company,      null: false, comment: '企業ID'
      t.string     :code,         null: false, comment: '部門コード'
      t.string     :name,         null: false, comment: '名称'
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end
