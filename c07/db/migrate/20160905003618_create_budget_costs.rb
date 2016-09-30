class CreateBudgetCosts < ActiveRecord::Migration[5.0]
  def change
    create_table :budget_costs, comment: '実行予算原価' do |t|
      t.references :budget,  null: false, index: true,       comment: '実行予算ID'
      t.references :cost,    null: false,                    comment: '原価ID'
      t.float      :expense_rate,                            comment: '経費率'
      t.column     :quotation_submitted_amount,    'bigint', comment: '見積提出予算'
      t.column     :quotation_initial_cost_amount, 'bigint', comment: '見積原価予算'
      t.column     :amount,                        'bigint', comment: '予算金額'
      t.column     :final_amount,                  'bigint', comment: '最終予算金額'
      t.string     :recital,                                 comment: '備考'

      t.integer    :created_by,                              comment: '作成者'
      t.integer    :updated_by,                              comment: '更新者'
      t.timestamps
    end
  end
end
