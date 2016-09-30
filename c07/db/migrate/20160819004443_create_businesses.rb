class CreateBusinesses < ActiveRecord::Migration[5.0]
  def change
    create_table :businesses, comment: '業務' do |t|
      t.references :company,           null: false, index: true, comment: '企業ID'
      t.string  :code,                 null: false,              comment: '業務コード(決算開始期 + 採算区分 + 業務コード数値部)(不要ではあるが検索で必要となる為、カラムで保持しておく)'
      t.string  :name,                 null: false,              comment: '業務名'
      t.integer :financial_start_year, null: false, limit: 2,    comment: '決算開始期'
      # FIXME: 事業区分
      t.references :profit_division,   null: false, index: true, comment: '採算区分ID'
      t.string  :code_number,          null: false,              comment: '業務コード数値部'
      t.integer :status,   default: 0, null: false, limit: 2,    comment: 'ステータス(0:初期状態, 99:決算処理済)'

      t.integer :created_by,                                     comment: '作成者ID'
      t.integer :updated_by,                                     comment: '更新者ID'
      t.timestamps
    end
  end
end
