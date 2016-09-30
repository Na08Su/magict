module QuotationHelper
  def costs_for_select
    # FIXME: 会社毎に変更
    current_company.costs.map do |cost|
      cost = ActiveDecorator::Decorator.instance.decorate(cost)
      [cost.code_with_name, cost.id]
    end
  end
end
