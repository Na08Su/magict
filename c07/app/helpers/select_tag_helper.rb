module SelectTagHelper
  # 工事関連
  concerning :Construction do
    def contract_divisions_for_select
      ContractConstruction.contract_divisions_i18n.invert
    end

    def construction_divisions_for_select
      ContractConstruction.construction_divisions_i18n.invert
    end

    def construction_order_statuses_for_select
      ContractConstruction.order_statuses_i18n.invert
    end
  end
  # 受注先関連
  concerning :Customer do
    def customer_categories_for_select
      ::Customer.categories_i18n.invert
    end

    def customer_cutoff_date_cycles_for_select
      ::Customer.cutoff_date_cycles_i18n.invert
    end
  end
  # 仕入先関連
  concerning :Vendor do
    def vendor_categories_for_select
      ::Vendor.categories_i18n.invert
    end
  end
  # 伝票
  concerning :Slip do
    def slip_types_for_select
      current_company.slip_types.map do |slip_type|
        [slip_type.name, slip_type.id]
      end
    end

    def slip_resources_for_select
      current_company.slip_resources.map do |slip_resource|
        [slip_resource.code, slip_resource.id]
      end
    end

    def cost_codes_for_select
      current_company.costs.map do |cost|
        [cost.code, cost.id]
      end
    end
  end

  def divisions_for_select
    current_company.divisions.map do |division|
      [division.code, division.id]
    end
  end

  def account_headings_for_select
    current_company.account_headings.map do |account_heading|
      [account_heading.code, account_heading.id]
    end
  end
end
