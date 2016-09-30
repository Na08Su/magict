module ConstructionInfoHelper
  def technical_employees_for_select
    current_company.employees.technical.map do |employee|
      employee = ActiveDecorator::Decorator.instance.decorate(employee)
      [employee.code_with_name, employee.id]
    end
  end

  def sales_employees_for_select
    current_company.employees.sales.map do |employee|
      employee = ActiveDecorator::Decorator.instance.decorate(employee)
      [employee.code_with_name, employee.id]
    end
  end

  def foreman_employees_for_select
    current_company.employees.foreman.map do |employee|
      employee = ActiveDecorator::Decorator.instance.decorate(employee)
      [employee.code_with_name, employee.id]
    end
  end

  def construction_probabilities_for_select
    MasterConstructionProbability.all_cache.select { |cp| Settings.construction_info.use_probability_ids.member?(cp.id) }.map do |cp|
      cp = ActiveDecorator::Decorator.instance.decorate(cp)
      [cp.code_with_name, cp.id]
    end
  end

  def customers_for_select
    current_company.customer_companies.map do |customer|
      [customer.name, customer.id]
    end
  end

  def construction_models_for_select
    # TODO: change to current_company.construction_models
    MasterConstructionModel.all_cache.map do |cm|
      [cm.name, cm.id]
    end
  end
end
