class SlipResourcesController < ApplicationController
  before_action :find_slip, only: [:edit, :update, :destroy, :restore]

  def index
    @query = current_company.slip_resources.search(search_params)
    search_result = @query.result
    search_result = search_result.with_deleted if search_params[:with_deleted].to_s == '1'
    @slip_resources = search_result.page(params[:page]).per(Settings.per_page).order(code: :asc)
  end

  def new
    @slip_resource = current_company.slip_resources.build
  end

  def create
    @slip_resource = current_company.slip_resources.build(slip_resource_params)
    if @slip_resource.save
      redirect_to slip_resources_path, flash: { notice: t('action.created', model_name: SlipResource.model_name.human, name: "#{ @slip_resource.code } : #{ @slip_resource.name }") }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @slip_resource.update(slip_resource_params)
      redirect_to slip_resources_path, flash: { notice: t('action.updated', model_name: SlipResource.model_name.human, name: "#{ @slip_resource.code } : #{ @slip_resource.name }") }
    else
      render :edit
    end
  end

  def destroy
    if @slip_resource.destroy
      redirect_to slip_resources_path, notice: t('action.deleted', model_name: SlipResource.model_name.human, name: "#{ @slip_resource.code } : #{ @slip_resource.name }")
    else
      render :edit
    end
  end

  def restore
    if @slip_resource.restore
      redirect_to slip_resources_path, flash: { notice: t('action.restored', model_name: SlipResource.model_name.human, name: "#{ @slip_resource.code } : #{ @slip_resource.name }") }
    else
      render :edit
    end
  end

  private

  def find_slip
    @slip_resource = current_company.slip_resources.with_deleted.find(params[:id])
  end

  def slip_resource_params
    params.require(:slip_resource).permit(:code, :name)
  end

  def search_params
    return {} if params[:q].blank?
    params.require(:q)
          .permit(:code_eq, :name_cont, :with_deleted)
  end
end
