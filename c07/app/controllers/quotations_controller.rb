class QuotationsController < ApplicationController
  before_action :find_quotation, only: [:update, :destroy]

  def index
    @query = current_company.quotations.search(search_params)
    @quotations = @query.result.includes(:quotation_details).page(params[:page]).per(Settings.per_page)
  end

  def new
    @quotation = current_company.quotations.build
  end

  def create
    @quotation = current_company.quotations.build(quotation_params)
    if @quotation.save
      redirect_to edit_quotation_path(@quotation),
        flash: { notice: t('action.created', model_name: @quotation.model_name.human, name: "#{ @quotation.no } : #{ @quotation.name }") }
    else
      render :new
    end
  end

  def edit
    @quotation = current_company.quotations.includes(quotation_details: [:cost]).find(params[:id])
  end

  def update
    if @quotation.update(quotation_params)
      redirect_to quotations_path,
        flash: { notice: t('action.updated', model_name: @quotation.model_name.human, name: "#{ @quotation.no } : #{ @quotation.name }") }
    else
      render :edit
    end
  end

  def destroy
    if @quotation.destroy
      redirect_to quotations_path,
        flash: { notice: t('action.deleted', model_name: @quotation.model_name.human, name: "#{ @quotation.no } : #{ @quotation.name }") }
    else
      render :edit
    end
  end

  def show_modal
    @query = current_company.quotations.search(params)
    @quotations = @query.result.includes(:quotation_details).page(params[:page]).per(Settings.per_page_modal)
  end

  def import
    Quotation.import_by_csv(params[:csv_file])
    redirect_to quotations_path, notice: 'success' # I18n.t('success.messages.add_rows', count: imported_row_count)
  rescue CsvImporter::RowInvalid, CsvImporter::FileInvalid => e
    redirect_to quotations_path, alert: e.message
  end

  private

  def quotation_params
    params.require(:quotation).permit(:no, :name, :submitted_date)
  end

  def search_params
    return {} if params[:q].blank?
    params.require(:q).permit(:no_cont, :name_cont, :submitted_date_eq).to_h
  end

  def find_quotation
    @quotation = current_company.quotations.find(params[:id])
  end
end
