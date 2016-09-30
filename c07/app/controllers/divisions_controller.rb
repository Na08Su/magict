class DivisionsController < ApplicationController
  before_action :find_division, only: [:edit, :update, :destroy, :restore]

  def index
    @query = current_company.divisions.search(search_params)
    search_result = @query.result
    search_result = search_result.with_deleted if search_params[:with_deleted].to_s == '1'
    @divisions = search_result.page(params[:page]).per(Settings.per_page).order(code: :asc)
  end

  def new
    @division = current_company.divisions.build
  end

  def create
    @division = current_company.divisions.build(division_params)
    if @division.save
      redirect_to divisions_path, flash: { notice: t('action.created', model_name: Division.model_name.human, name: "#{ @division.code } : #{ @division.name }") }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @division.update(division_params)
      redirect_to divisions_path, flash: { notice: t('action.updated', model_name: Division.model_name.human, name: "#{ @division.code } : #{ @division.name }") }
    else
      render :edit
    end
  end

  def destroy
    if @division.destroy
      redirect_to divisions_path, flash: { notice: t('action.deleted', model_name: Division.model_name.human, name: "#{ @division.code } : #{ @division.name }") }
    else
      render :edit
    end
  end

  def restore
    if @division.restore
      redirect_to divisions_path, flash: { notice: t('action.restored', model_name: Division.model_name.human, name: "#{ @division.code } : #{ @division.name }") }
    else
      render :edit
    end
  end

  private

  def find_division
    @division = current_company.divisions.with_deleted.find(params[:id])
  end

  def search_params
    return {} if params[:q].blank?
    params.require(:q).permit(:code_eq, :name_cont, :with_deleted)
  end

  def division_params
    params.require(:division).permit(:code, :name)
  end
end
