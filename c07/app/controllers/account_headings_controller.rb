class AccountHeadingsController < ApplicationController
  before_action :find_account_heading, only: [:edit, :update, :destroy]

  def index
    @query = current_company.account_headings.search(search_params)
    search_result = @query.result
    search_result = search_result.with_deleted if search_params[:with_deleted].to_s == '1' # trueならば表示

    respond_to do |format|
      format.html do
        @account_headings = search_result.page(params[:page]).per(Settings.per_page).order(code: :asc)
      end
      format.csv do
        @account_headings = search_result.order(code: :asc)
      end
    end
  end

  def new
    @account_heading = current_company.account_headings.build
  end

  def create
    @account_heading = current_company.account_headings.build(account_heading_params)
    if @account_heading.save
      redirect_to account_headings_path, flash: { notice: t('action.created', model_name: AccountHeading.model_name.human, name: "#{ @account_heading.code } : #{ @account_heading.name }") }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @account_heading.update(account_heading_params)
      redirect_to account_headings_path, flash: { notice: t('action.updated', model_name: AccountHeading.model_name.human, name: "#{ @account_heading.code } : #{ @account_heading.name }") }
    else
      render :edit
    end
  end

  def destroy
    if @account_heading.destroy
      redirect_to account_headings_path, flash: { notice: t('action.deleted', model_name: AccountHeading.model_name.human, name: "#{ @account_heading.code } : #{ @account_heading.name }") }
    else
      render :edit
    end
  end

  private

  def find_account_heading
    @account_heading = current_company.account_headings.find(params[:id])
  end

  def search_params
    return {} if params[:q].blank?
    @_search_params ||= params.require(:q).permit(:code_cont, :name_cont, :division_eq, :with_deleted).to_h
  end

  def account_heading_params
    params.require(:account_heading).permit(:code, :name, :division)
  end
end
