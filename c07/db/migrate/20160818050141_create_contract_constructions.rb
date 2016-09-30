class CreateContractConstructions < ActiveRecord::Migration[5.0]
  def change
    create_table :contract_constructions, comment: '担当工事' do |t|
      t.references :company,            null: false, index: true, comment: '企業ID'
      t.references :construction_info,               index: true, comment: '工事情報ID'
      t.references :business,           null: false, index: true, comment: '業務ID'
      t.integer :financial_year,        null: false,              comment: '決算期'
      t.string  :code,                  null: false,              comment: '工番'
      t.string  :name,                  null: false,              comment: '工事名'
      t.date    :schedule_start,                                  comment: '工事工程 開始日'
      t.date    :schedule_end,                                    comment: '工事工程 終了日'
      t.date    :enactment_schedule_start,                        comment: '施工工程 開始日'
      t.date    :enactment_schedule_end,                          comment: '施工工程 終了日'
      t.integer :construction_division, limit: 2,                 comment: '工事区分'
      t.integer :contract_division,     limit: 2,                 comment: '請負区分'
      t.integer :technical_employee_id,                           comment: '技術担当者'
      t.integer :sales_employee_id,                               comment: '営業担当者'
      t.integer :foreman_employee_id,                             comment: '工事担当者'
      t.references :quotation,                                    comment: '見積'
      t.string  :decision_no,                                     comment: '決定NO'
      t.column  :decision_amount,     'bigint',                   comment: '決定金額'
      t.column  :decision_amount_tax, 'bigint',                   comment: '決定金額消費税'
      t.date    :decision_date,                                   comment: '決定日付'
      t.integer :order_status,          limit: 2, default: 1,     comment: '受注ステータス'
      t.integer :progress,              limit: 2, default: 0,     comment: '進捗'
      t.string  :recital,                                         comment: '備考'

      t.integer :created_by,                                      comment: '作成者ID'
      t.integer :updated_by,                                      comment: '更新者ID'
      t.timestamps
    end
  end
end
