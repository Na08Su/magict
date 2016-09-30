class SlipTypesController < ApplicationController
  before_action :find_slip_type, only: [:edit, :update, :destroy, :restore]
  def index
    @query = current_company.slip_types.search(search_params)
    search_result = @query.result
    search_result = search_result.with_deleted if search_params[:with_deleted].to_s == '1'
    @slip_types = search_result.page(params[:page]).per(Settings.per_page).order(order_number: :asc)
  end

  def new
    @slip_type = current_company.slip_types.build
  end

  def create
    @slip_type = current_company.slip_types.build(slip_type_params)
    if @slip_type.save
      redirect_to slip_types_path, flash: { notice: t('action.created', model_name: SlipType.model_name.human, name: "#{ @slip_type.code } : #{ @slip_type.name }") }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @slip_type.update(slip_type_params)
      redirect_to slip_types_path, flash: { notice: t('action.updated', model_name: SlipType.model_name.human, name: "#{ @slip_type.code } : #{ @slip_type.name }") }
    else
      render :edit
    end
  end

  def destroy
    if @slip_type.destroy
      redirect_to slip_types_path, notice: t('action.deleted', model_name: SlipResource.model_name.human, name: "#{ @slip_type.code } : #{ @slip_type.name }")
    else
      render :edit
    end
  end

  def restore
    if @slip_type.restore
      redirect_to slip_types_path, flash: { notice: t('action.restored', model_name: SlipType.model_name.human, name: "#{ @slip_type.code } : #{ @slip_type.name }") }
    else
      render :edit
    end
  end

  private

  def find_slip_type
    @slip_type = current_company.slip_types.with_deleted.find(params[:id])
  end

  def slip_type_params
    params.require(:slip_type).permit(:code, :name, :order_number)
  end

  def search_params
    return {} if params[:q].blank?
    params.require(:q).permit(:code_eq, :name_cont, :order_number_eq, :with_deleted)
  end
end
