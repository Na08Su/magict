class CreateCompanySettings < ActiveRecord::Migration[5.0]
  def change
    create_table :company_settings, comment: 'システム共通設定' do |t|
      t.references :company,             null: false, comment: '企業ID'
      t.integer    :financial_year,      null: false, comment: '期'
      t.integer    :closing_first_year,  null: false, comment: '決算1期目の年'
      t.integer    :closing_start_month, null: false, commnet: '決算開始月'
      t.float      :consumption_tax,     null: false, comment: '消費税'
      t.timestamps
    end
  end
end
