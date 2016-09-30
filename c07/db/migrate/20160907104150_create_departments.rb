class CreateDepartments < ActiveRecord::Migration[5.0]
  def change
    create_table :departments, comment: '部署マスタ' do |t|
      t.references :division,  null: false, comment: '部門ID'
      t.string     :code,      null: false, comment: 'コード'
      t.string     :name,      null: false, comment: '部署名'
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end
