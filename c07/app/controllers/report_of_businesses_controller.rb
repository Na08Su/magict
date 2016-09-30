class ReportOfBusinessesController < ApplicationController
  before_action :set_construction_summary_data, only: [:construction_summary, :export_construction_summary]

  def construction_summary
  end

  def export_construction_summary
    builder = JsonReportBuilder::ExcelReport::Builder::ReportOfBusinessesReportBuilder.new
    builder.import('construction_summary', construction_summary: @construction_summary)
    output_file_name = JsonReportBuilder.create(tmp_file_name: controller_name, builder: builder, separate: current_user.id.to_s)
    send_file(output_file_name)
  rescue => e
    flash.now[:alert] = e.message
    render :construction_summary
  end

  private

  def set_construction_summary_data
    @construction_summary = Report::ConstructionSummary.new(current_company: current_company, search_params: search_params)
  end

  def search_params
    return {} if params[:q].blank?
    params.require(:q).permit(:financial_year_gteq).to_h
  end
end
