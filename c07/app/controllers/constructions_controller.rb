class ConstructionsController < ApplicationController
  def show_modal
    @query = Construction.search(params)
    @constructions = @query.result.includes(:joint_venture, :company_sub_classification, site: [main_site: [:prefecture]])
                           .page(params[:page]).per(Settings.per_page_modal)
  end
end
