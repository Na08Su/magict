class CreateQuotations < ActiveRecord::Migration[5.0]
  def change
    create_table :quotations, comment: '見積' do |t|
      t.references :company, null: false, index: true, comment: '企業ID'
      t.string     :no,      null: false,              comment: '見積NO'
      t.string     :name,                              comment: '見積名'
      t.date       :submitted_date,                    comment: '見積提出日'

      t.integer :created_by,           comment: '作成者'
      t.integer :updated_by,           comment: '更新者'
      t.timestamps
    end
  end
end
