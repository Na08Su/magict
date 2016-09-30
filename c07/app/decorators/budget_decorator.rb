module BudgetDecorator
  def total_amount
    budget_costs.map(&:amount).compact.sum
  end

  def total_final_amount
    budget_costs.map(&:final_amount).compact.sum
  end
end
