class QuotationDetailsController < ApplicationController
  def index
    @quotation = current_company.quotations.includes(:quotation_details).find(params[:quotation_id])
    @quotation.quotation_details.build if @quotation.quotation_details.size.zero?
  end

  def create
    @quotation = current_company.quotations.find(params[:quotation_id])
    if @quotation.update(quotation_params)
      redirect_to edit_quotation_path(@quotation),
        flash: { notice: t('action.updated', model_name: QuotationDetail.model_name.human, name: "#{ @quotation.no } : #{ @quotation.name }") }
    else
      @quotation.quotation_details.sort_by(&:row_number)
      render :index
    end
  end

  def quotation_params
    return {} if params[:quotation].blank?
    params.require(:quotation).permit(quotation_details_attributes:
      [:id, :row_number, :cost_id, :name1, :name2, :unit, :submitted_quantity, :submitted_price, :initial_cost_quantity, :initial_cost_price, :_destroy])
  end
end
