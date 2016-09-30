class BusinessesController < CrudBaseController
  resource_klass Business
  resource_params :business_params
  resource_crud_options index_order_by: { code: :desc }, flash_message_attribute: :name
  before_action :set_ransack_query, only: [:index, :export_excel]

  def index
    @businesses = search_result.page(params[:page]).per(Settings.per_page)
  end

  def export_excel
    builder = JsonReportBuilder::ExcelReport::Builder::BusinessesReportBuilder.new
    builder.import('index', businesses: search_result)
    output_file_name = JsonReportBuilder.create(tmp_file_name: controller_name, builder: builder, separate: current_user.id.to_s)
    send_file(output_file_name)
  rescue => e
    @businesses = search_result.page(params[:page]).per(Settings.per_page)
    flash.now[:alert] = e.message
    render :index
  end

  def new
    @business = current_company.businesses.build(financial_start_year: current_financial_year)
    @business.build_code_number
  end

  def create
    @business = current_company.businesses.build(business_params)
    if @business.save
      redirect_to businesses_path, flash: { notice: t('action.created', model_name: @business.model_name.human, name: @business.send(flash_message_attribute)) }
    else
      render :new
    end
  end

  def show_modal
    @query = Business.search(params)
    @businesses = @query.result.includes(:contract_constructions).page(params[:page]).per(Settings.per_page_modal)
  end

  private

  def search_params
    return {} if params[:q].blank?
    params.require(:q).permit(:code_cont, :name_cont, :financial_start_year_eq).to_h
  end

  def business_params
    params.require(:business).permit(:name, :financial_start_year, :code_number, :profit_division_id)
  end

  def set_ransack_query
    @query = Business.search(search_params)
  end

  def search_result
    @query.result.includes(:contract_constructions).order(code: :desc)
  end
end
