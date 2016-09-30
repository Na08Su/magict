class CreateMasterConstructionProbabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :master_construction_probabilities do |t|
      t.string :code,       null: false, comment: '受注確率CD'
      t.string :name,       null: false, comment: '受注確率名'

      t.integer  :created_by,            comment: '作成者ID'
      t.integer  :updated_by,            comment: '更新者ID'
      t.datetime :deleted_at,            comment: '削除日時'
      t.timestamps
    end
  end
end
