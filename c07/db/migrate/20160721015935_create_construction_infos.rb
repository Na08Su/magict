class CreateConstructionInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :construction_infos, comment: '営業中工事情報' do |t|
      t.references :company,            null: false, index: true,     comment: '企業ID'
      t.string     :site_name,          null: false,                  comment: '現場名'
      t.string     :construction_name,  null: false,                  comment: '工事名'
      t.string     :enactment_location, null: false,                  comment: '施工場所(市町村名)'
      t.integer    :financial_year,     null: false,                  comment: '決算期'
      t.references :master_construction_model,       index: true,     comment: '受注形態ID'
      t.references :master_construction_probability, index: true,     comment: '受注確率ID'
      t.integer    :first_master_construction_probability_id,         comment: '登録時受注確率ID'
      t.integer    :customer_company_id,                              comment: '受注先'
      t.date       :schedule_start,                                   comment: '工事工程 開始日'
      t.date       :schedule_end,                                     comment: '工事工程 終了日'
      t.date       :enactment_schedule_start,                         comment: '施工工程 開始日'
      t.date       :enactment_schedule_end,                           comment: '施工工程 終了日'
      t.integer    :technical_employee_id,                            comment: '技術担当者'
      t.integer    :sales_employee_id,                                comment: '営業担当者'
      t.integer    :foreman_employee_id,                              comment: '工事担当者'
      t.string     :building_contractor,                              comment: '建築業者'
      t.column     :expected_amount,      'bigint',                   comment: '予定金額'
      t.references :quotation,                                        comment: '見積'
      t.references :master_bill_division,            index: true,     comment: '請求区分ID'
      t.string     :recital,                                          comment: '備考'

      t.integer :created_by,                                          comment: '作成者ID'
      t.integer :updated_by,                                          comment: '更新者ID'
      t.timestamps
    end
  end
end
