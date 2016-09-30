class AddColumnCodeToEmployees < ActiveRecord::Migration[5.0]
  def change
    # add_column :employees, :code,           :string, limit: 30,       comment: '社員コード'
    # add_column :employees, :technical_flag, :boolean, default: false, comment: '技術担当者フラグ'
    # add_column :employees, :sales_flag,     :boolean, default: false, comment: '営業担当者フラグ'
    # add_column :employees, :foreman_flag,   :boolean, default: false, comment: '工事担当者フラグ'

    # add_index :employees, :technical_flag
    # add_index :employees, :sales_flag
    # add_index :employees, :foreman_flag
  end
end
