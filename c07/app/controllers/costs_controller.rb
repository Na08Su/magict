class CostsController < ApplicationController
  before_action :find_cost, only: [:edit, :update, :destroy, :restore]

  def index
    @query = current_company.costs.search(search_params)
    respond_to do |format|
      format.html do
        search_result = @query.result
        search_result = search_result.with_deleted if search_params[:with_deleted].to_s == '1' # trueならば表示
        @costs = search_result.page(params[:page]).per(Settings.per_page).order(code: :asc)
      end
      format.csv  { @costs = @query.result.order(code: :asc) }
    end
  end

  def new
    @cost = current_company.costs.build
  end

  def create
    @cost = current_company.costs.build(cost_params)
    if @cost.save
      redirect_to costs_path, flash: { notice: t('action.created', model_name: Cost.model_name.human, name: "#{ @cost.code } : #{ @cost.name }") }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @cost.update(cost_params)
      redirect_to costs_path, flash: { notice: t('action.updated', model_name: Cost.model_name.human, name: "#{ @cost.code } : #{ @cost.name }") }
    else
      render :edit
    end
  end

  def destroy
    if @cost.destroy
      redirect_to costs_path, flash: { notice: t('action.deleted', model_name: Cost.model_name.human, name: "#{ @cost.code } : #{ @cost.name }") }
    else
      render :edit
    end
  end

  def restore
    if @cost.restore
      redirect_to costs_path, flash: { notice: t('action.restored', model_name: Cost.model_name.human, name: "#{ @cost.code } : #{ @cost.name }") }
    else
      render :edit
    end
  end

  def import
    imported_row_count = Cost.import_by_csv(params[:csv_file])
    redirect_to costs_path, notice: I18n.t('success.messages.add_rows', count: imported_row_count)
  rescue CsvImporter::RowInvalid, CsvImporter::FileInvalid => e
    redirect_to costs_path, alert: e.message
  end

  private

  def find_cost
    @cost = current_company.costs.with_deleted.find(params[:id])
  end

  def search_params
    return {} if params[:q].blank?
    @_search_params ||= params.require(:q).permit(:code_cont, :name_cont, :cost_class_eq, :budget_class_eq, :with_deleted).to_h
  end

  def cost_params
    params.require(:cost).permit(:code, :name, :account_heading_id, :cost_class, :budget_class)
  end
end
