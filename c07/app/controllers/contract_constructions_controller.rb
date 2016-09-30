class ContractConstructionsController < CrudBaseController
  resource_klass ContractConstruction
  resource_params :contract_construction_params
  skip_before_action :find_resource, only: [:edit]
  before_action :set_ransack_query, only: [:index, :export_excel]
  before_action :configure_tax_rate_to_gon, only: [:new, :create, :edit, :update]

  def index
    @contract_constructions = search_result.order('businesses.code desc').page(params[:page]).per(Settings.per_page)
  end

  def export_excel
    builder = JsonReportBuilder::ExcelReport::Builder::ContractConstructionsReportBuilder.new
    builder.import('index', contract_constructions: search_result.order(:financial_year, 'businesses.code desc', :code).group_by(&:financial_year))
    output_file_name = JsonReportBuilder.create(tmp_file_name: controller_name, builder: builder, separate: current_user.id.to_s)
    send_file(output_file_name)
  rescue => e
    @contract_constructions = search_result.order('businesses.code desc').page(params[:page]).per(Settings.per_page)
    flash.now[:alert] = e.message
    render :index
  end

  def new
    @contract_construction = current_company.contract_constructions.build(decision_no: t('form.input.auto_numbering'), financial_year: current_financial_year)
  end

  def create
    @contract_construction = current_company.contract_constructions.build(contract_construction_params)
    ApplicationRecord.transaction do
      @contract_construction.save!
      @contract_construction.construction_info.update_contract_probability!
      redirect_to contract_constructions_path, flash: { notice: t('action.created', model_name: @contract_construction.model_name.human, name: @contract_construction.name) }
    end
  rescue
    @contract_construction[:decision_no] = t('form.input.auto_numbering')
    render :new
  end

  def edit
    @contract_construction = current_company.contract_constructions.includes(:technical_employee, :sales_employee, :foreman_employee,
                                                           quotation: [:quotation_details]).find(params[:id])
  end

  def reflection_by_financial_year_and_code
    @destination_id = params[:destination_id]
    @destination_name = params[:destination_name]
    @contract_construction = current_company.contract_constructions.find_by(financial_year: params[:financial_year], code: params[:code])
  end

  private

  def search_params
    return {} if params[:q].blank?
    params.require(:q)
          .permit(:code_cont, :name_cont, :schedule_start_gteq, :schedule_end_lteq, :financial_year_eq).to_h
  end

  def contract_construction_params
    params.require(:contract_construction).permit(
      :business_id, :construction_info_id, :quotation_id,
      :financial_year, :code, :name, :schedule_start, :schedule_end,
      :enactment_schedule_start, :enactment_schedule_end,
      :technical_employee_id, :sales_employee_id, :foreman_employee_id,
      :decision_amount, :decision_amount_tax,
      :construction_division, :contract_division,
      :order_status
    )
  end

  def set_ransack_query
    @query = ContractConstruction.search(search_params)
  end

  def search_result
    @query.result.includes(:business, :budget)
  end
end
