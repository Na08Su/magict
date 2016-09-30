class CompaniesController < ApplicationController
  def show_modal
    parameters = params[:q] ? params.require(:q).permit(:name_cont).to_h : {}
    @query = Company.search(parameters)
    @companies = @query.result.page(params[:page]).per(Settings.per_page_api).order(name: :asc)
  end
end
