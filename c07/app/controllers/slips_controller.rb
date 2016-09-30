class SlipsController < ApplicationController
  before_action :find_slip, only: [:update, :destroy]
  before_action :slip_detail_params_to_gon, except: [:index]

  def index
    @query = current_company.slips.search(search_params)
    @slips = @query.result.includes(:slip_details).page(params[:page]).per(Settings.per_page)
  end

  def new
    @slip = current_company.slips.build
    @slip.slip_details.build
    @slip.auto_numbering(current_company.slips.size)
  end

  def create
    @slip = current_company.slips.build(slip_params)
    if @slip.save
      redirect_to edit_slip_path(@slip),
        flash: { notice: t('action.created', model_name: @slip.model_name.human, name: @slip.code) }
    else
      render :new
    end
  end

  def edit
    @slip = current_company.slips.includes(slip_details: [:cost]).find(params[:id])
  end

  def update
    if @slip.update(slip_params)
      redirect_to slips_path,
        flash: { notice: t('action.updated', model_name: @slip.model_name.human, name: @slip.code) }
    else
      render :edit
    end
  end

  def destroy
    if @slip.destroy
      redirect_to slips_path,
        flash: { notice: t('action.deleted', model_name: @slip.model_name.human, name: @slip.code) }
    else
      render :edit
    end
  end

  private

  def slip_params
    params.require(:slip).permit(:code, :financial_year, :slip_type_id, :slip_date, :created_at,
      slip_details_attributes: [
        :id, :row_number, :slip_resource_id, :division_id, :contract_construction_id, :cost_id,
        :debit_account_heading_id, :credit_account_heading_id,
        :summary, :summary_item, :summary_date, :amount, :_destroy
      ])
  end

  def search_params
    return {} if params[:q].blank?
    params.require(:q).permit(:financial_year_eq, :slip_type_id_eq, :code_cont, :slip_date_eq, :created_at_eq).to_h
  end

  def find_slip
    @slip = current_company.slips.find(params[:id])
  end

  def slip_detail_params_to_gon
    gon.account_headings = current_company.account_headings.map { |ah| [ah.id, ah.name] }.to_h
    gon.slip_resources = current_company.slip_resources.map { |ah| [ah.id, ah.name] }.to_h
    gon.divisions = current_company.divisions.map { |ah| [ah.id, ah.name] }.to_h
    gon.costs = current_company.costs.map { |ah| [ah.id, ah.name] }.to_h
  end
end
