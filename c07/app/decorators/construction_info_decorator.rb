module ConstructionInfoDecorator
  def attributes_for_modal
    attrs = HashWithIndifferentAccess[attributes.map { |key, val| [key, val.is_a?(Date) ? I18n.l(val) : val] }]
    quotation.try(:attributes_for_modal).try(:each) do |key, val|
      attrs["quotation_#{ key }"] = val
    end
    attrs[:technical_employee_name] = technical_employee.try(:name)
    attrs[:sales_employee_name] = sales_employee.try(:name)
    attrs[:foreman_employee_name] = foreman_employee.try(:name)
    attrs[:customer_company_name] = customer_company.try(:name)
    attrs[:master_construction_model_name] = master_construction_model.try(:name)
    attrs[:first_master_construction_probability_name] = first_master_construction_probability.try(:name)
    attrs[:master_construction_probability_name] = master_construction_probability.try(:name)
    attrs[:master_bill_division_name] = master_bill_division.try(:name)
    attrs[:expected_amount] = expected_amount.try(:to_s, :delimited)
    attrs
  end

  def schedule
    "#{ schedule_start } - #{ schedule_end }"
  end

  def enactment_schedule
    "#{ enactment_schedule_start } - #{ enactment_schedule_end }"
  end
end
