class AddColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    ## Omniauthable
    ## providerと連携しなくとも動かせるように、null: falseは付けない
    # add_column :users, :uid, :string, limit: 8
    # add_column :users, :provider, :string
    # add_column :users, :token, :string
    # add_column :users, :company_admin_flag, :boolean, default: false
  end
end
