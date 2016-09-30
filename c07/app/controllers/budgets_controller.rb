class BudgetsController < ApplicationController
  before_action :configure_costs_to_gon
  before_action :find_contract_construction
  before_action :find_budget, only: [:edit, :update, :destroy]

  def new
    @budget = @contract_construction.build_budget(no: t('form.input.auto_numbering'))
  end

  def create
    @budget = @contract_construction.build_budget(budget_params)
    if @budget.save
      redirect_to contract_constructions_path, flash: { notice: t('action.created', model_name: Budget.model_name.human, name: @budget.no) }
    else
      render :new
    end
  end

  def edit
    @budget = @contract_construction.budget
  end

  def update
    @budget = @contract_construction.budget
    if @budget.update(budget_params)
      redirect_to contract_constructions_path, flash: { notice: t('action.updated', model_name: Budget.model_name.human, name: @budget.no) }
    else
      render :edit
    end
  end

  def destroy
    if @budget.destroy
      redirect_to contract_constructions_path, flash: { notice: t('action.deleted', model_name: Budget.model_name.human, name: @budget.no) }
    else
      render :edit
    end
  end

  # 見積から反映
  def costs_reflect_from_quotation
    @budget = @contract_construction.budget || @contract_construction.build_budget
    @budget.assign_attributes(budget_params)
    @budget.costs_reflect_from_quotation

    render :new
  end

  private

  def find_contract_construction
    @contract_construction = current_company.contract_constructions.includes(
      quotation: [:quotation_details], budget: [budget_costs: [:cost]]
    ).find(params[:contract_construction_id])
  end

  def find_budget
    @budget = @contract_construction.budget || @contract_construction.build_budget(no: t('form.input.auto_numbering'))
  end

  def budget_params
    return {} if params[:budget].blank?
    params.require(:budget).permit(budget_costs_attributes:
      [:id, :cost_id, :expense_rate, :quotation_submitted_amount, :quotation_initial_cost_amount,
       :amount, :final_amount, :recital, :_destroy])
  end
end
