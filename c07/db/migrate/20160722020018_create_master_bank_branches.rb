class CreateMasterBankBranches < ActiveRecord::Migration[5.0]
  def change
    create_table :master_bank_branches, comment: '銀行支店マスタ' do |t|
      t.string :master_bank_code, null: false, comment: '銀行コード'
      t.string :code,             null: false, comment: '支店コード'
      t.string :name,             null: false, comment: '支店名'
      t.string :name_kana,        null: false, comment: '支店名カナ'

      t.timestamps
    end

    add_index :master_bank_branches, :master_bank_code
  end
end
