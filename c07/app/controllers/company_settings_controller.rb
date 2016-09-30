class CompanySettingsController < ApplicationController
  def edit
    @company_setting = current_company.company_setting || current_company.build_company_setting
  end

  def update
    @company_setting = current_company.company_setting || current_company.build_company_setting
    @company_setting.assign_attributes(company_setting_params)

    if @company_setting.save
      redirect_to edit_company_setting_path, notice: I18n.t('success.messages.update_setting')
    else
      render :edit
    end
  end

  private

  def company_setting_params
    params.require(:company_setting).permit(:financial_year, :closing_first_year, :closing_start_month, :consumption_tax)
  end
end
