class BudgetCost < ApplicationRecord
  belongs_to :budget, inverse_of: :budget_costs
  belongs_to :cost, -> { with_deleted }

  delegate :contract_construction, to: :budget

  def amount_ratio
    return nil if amount.blank? || contract_construction.decision_amount.blank?
    ((amount / contract_construction.decision_amount.to_f) * 100).round(1)
  end

  def final_amount_ratio
    return nil if final_amount.blank? || contract_construction.decision_amount.blank?
    ((final_amount / contract_construction.decision_amount.to_f) * 100).round(1)
  end
end
