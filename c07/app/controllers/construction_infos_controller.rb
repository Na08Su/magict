class ConstructionInfosController < ApplicationController
  before_action :find_construction_info, only: [:update, :destroy]
  before_action :set_ransack_query_for_expect_order_list, only: [:expect_order_list, :export_excel_for_expect_order_list]

  def index
    @query = ConstructionInfo.search(search_params)
    @construction_infos = @query.result.order(id: :desc).page(params[:page]).per(Settings.per_page)
  end

  def new
    @construction_info = current_company.construction_infos.build(financial_year: current_financial_year)
  end

  def create
    @construction_info = current_company.construction_infos.new(construction_info_params)
    if @construction_info.save
      redirect_to construction_infos_path, flash: { notice: t('action.created', model_name: ConstructionInfo.model_name.human, name: @construction_info.construction_name) }
    else
      render :new
    end
  end

  def edit
    @construction_info = current_company.construction_infos.includes(:master_construction_model, :master_construction_probability,
                                                                     :master_bill_division, :technical_employee, :sales_employee, :foreman_employee,
                                                                     quotation: [:quotation_details]).find(params[:id])
  end

  def update
    if @construction_info.update(construction_info_params)
      redirect_to construction_infos_path, flash: { notice: t('action.updated', model_name: ConstructionInfo.model_name.human, name: @construction_info.construction_name) }
    else
      render :edit
    end
  end

  def destroy
    if @construction_info.destroy
      redirect_to construction_infos_path, flash: { notice: t('action.deleted', model_name: ConstructionInfo.model_name.human, name: @construction_info.construction_name) }
    else
      render :edit
    end
  end

  def show_modal
    @query = ConstructionInfo.search(params)
    @construction_infos = @query.result.includes(:master_construction_model, :master_construction_probability, :master_bill_division,
                                                 :technical_employee, :sales_employee, :foreman_employee, :customer_company,
                                                 quotation: [:quotation_details]).page(params[:page]).per(Settings.per_page_modal)
  end

  def expect_order_list
    @construction_infos = search_result_for_expect_order_list
  end

  def export_excel_for_expect_order_list
    builder = JsonReportBuilder::ExcelReport::Builder::ConstructionInfosReportBuilder.new
    builder.import('expect_order_list', construction_infos: search_result_for_expect_order_list, order_by_probability: @order_by_probability)
    output_file_name = JsonReportBuilder.create(tmp_file_name: controller_name, builder: builder, separate: current_user.id.to_s)
    send_file(output_file_name)
  rescue => e
    @construction_infos = search_result_for_expect_order_list
    flash.now[:alert] = e.message
    render :expect_order_list
  end

  private

  def search_params
    return {} if params[:q].blank?
    params.require(:q)
          .permit(:id_cont, :site_name_cont, :construction_name_cont, :schedule_start_gteq, :schedule_end_lteq, :master_construction_probability_id_eq, :financial_year_eq).to_h
  end

  def search_expect_order_list_params
    return {} if params[:q].blank?
    params.require(:q)
          .permit(:financial_year_gteq, :master_construction_probability_id_lteq, :master_construction_probability_id_gteq,
                  :expected_amount_gteq, :master_construction_model_id_eq, :sales_employee_id_eq).to_h
  end

  def construction_info_params
    params.require(:construction_info)
          .permit(:site_name, :construction_name, :enactment_location, :master_construction_model_id,
                  :master_construction_probability_id, :customer_company_id, :financial_year,
                  :schedule_start, :schedule_end, :enactment_schedule_start, :enactment_schedule_end,
                  :technical_employee_id, :sales_employee_id, :foreman_employee_id, :building_contractor,
                  :expected_amount, :master_bill_division_id, :recital, :quotation_id)
  end

  def find_construction_info
    @construction_info = current_company.construction_infos.find(params[:id])
  end

  def set_ransack_query_for_expect_order_list
    params[:order_by] = 'master_construction_probability_id' if params[:order_by].blank?
    @order_by_probability = params[:order_by] == 'master_construction_probability_id'
    @query = ConstructionInfo.search(search_expect_order_list_params)
  end

  def search_result_for_expect_order_list
    @query.result.includes(:master_construction_probability, :master_construction_model, :sales_employee,
                           :customer_company, quotation: [:quotation_details])
                          .order(params[:order_by]).group_by(&params[:order_by].to_sym)
  end
end
