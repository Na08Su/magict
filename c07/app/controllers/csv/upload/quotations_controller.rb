require 'csv_importer/base'

module Csv
  module Upload
    class QuotationsController < ::ApplicationController
      def index
        @quotation = Quotation.new
      end

      def execute
        @quotation = Quotation.new(quotation_params)
        @quotation.import_details_from_csv_files(params[:csv_files])

        redirect_to quotations_path, flash: { notice: t('action.created', model_name: Quotation.human_attribute_name(:no), name: @quotation.no) }
      rescue ActiveRecord::RecordInvalid, CsvImporter::RowInvalid, CsvImporter::FileInvalid => e
        flash.now[:alert] = e.message
        render action: :index
      end

      def quotation_params
        params.require(:quotation).permit(:no, :name, :submitted_date)
      end
    end
  end
end
