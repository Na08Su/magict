class CreateQuotationDetails < ActiveRecord::Migration[5.0]
  def change
    # NOTE: quotation_idがnot_nullになっていないのは、
    # quotation_id, またはparent_idのどちらかが入力されていればよい為. validationで制御する
    create_table :quotation_details, comment: '見積詳細(行単位)' do |t|
      t.integer    :quotation_id,                           comment: '見積ID'
      t.integer    :cost_id,                                comment: '原価ID'
      t.integer    :row_number,   null: false,              comment: '行番号'
      t.string     :name1,        null: false,              comment: '名称1'
      t.string     :name2,                                  comment: '名称2'
      t.string     :unit,                                   comment: '単位'
      t.integer    :submitted_quantity,                     comment: '提出数量'
      t.column     :submitted_price,    'bigint',           comment: '提出単価'
      t.integer    :initial_cost_quantity,                  comment: '原価数量'
      t.column     :initial_cost_price, 'bigint',           comment: '原価単価'

      t.integer    :created_by,                             comment: '作成者'
      t.integer    :updated_by,                             comment: '更新者'
      t.timestamps
    end

    add_index :quotation_details, :quotation_id
  end
end
