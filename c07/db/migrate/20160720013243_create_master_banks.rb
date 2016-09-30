class CreateMasterBanks < ActiveRecord::Migration[5.0]
  def change
    create_table :master_banks, id: false, comment: '銀行マスタ' do |t|
      t.string   :code,      null: false, comment: '銀行コード'
      t.string   :name,      null: false, comment: '銀行名'
      t.string   :name_kana, null: false, comment: '銀行名カナ'

      t.timestamps
    end

    execute 'ALTER TABLE master_banks ADD PRIMARY KEY (code)'
  end
end
