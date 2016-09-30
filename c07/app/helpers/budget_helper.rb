module BudgetHelper
  def options_for_cost_select(budget_class: nil, selected: nil)
    budget_class = budget_class.presence || Cost.budget_classes[:class_a]
    costs = current_company.costs.where(budget_class: budget_class).sort_by(&:id).map { |c| ActiveDecorator::Decorator.instance.decorate(c) }
    selected = selected.presence || costs.first.id

    options_for_select(costs.map { |c| [c.code_with_name, c.id] }, selected)
  end
end
