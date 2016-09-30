class DepartmentsController < ApplicationController
  before_action :find_division
  before_action :find_department, only: [:edit, :update, :destroy, :restore]

  def index
    @query = @division.departments.search(search_params)
    search_result = @query.result
    search_result = search_result.with_deleted if search_params[:with_deleted].to_s == '1'
    @departments = search_result.page(params[:page]).per(Settings.per_page).order(code: :asc)
  end

  def new
    @department = @division.departments.build
  end

  def create
    @department = @division.departments.build(department_params)
    if @department.save
      redirect_to division_departments_path, flash: { notice: t('action.created', model_name: Department.model_name.human, name: "#{ @department.code } : #{ @department.name }") }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @department.update(department_params)
      redirect_to division_departments_path(division_id: @department.division_id), flash: { notice: t('action.updated', model_name: Department.model_name.human, name: "#{ @department.code } : #{ @department.name }") }
    else
      render :edit
    end
  end

  def destroy
    if @department.destroy
      redirect_to division_departments_path(division_id: @department.division_id), notice: t('action.deleted', model_name: Department.model_name.human, name: "#{ @department.code } : #{ @department.name }")
    else
      render :edit
    end
  end

  def restore
    if @department.restore
      redirect_to division_departments_path(division_id: @department.division_id), flash: { notice: t('action.restored', model_name: Department.model_name.human, name: "#{ @department.code } : #{ @department.name }") }
    else
      render :edit
    end
  end

  private

  def find_division
    @division = current_company.divisions.find(params[:division_id])
  end

  def find_department
    @department = @division.departments.with_deleted.find(params[:id])
  end

  def department_params
    params.require(:department).permit(:code, :name)
  end

  def search_params
    return {} if params[:q].blank?
    params.require(:q)
          .permit(:code_eq, :name_cont, :with_deleted)
  end
end
