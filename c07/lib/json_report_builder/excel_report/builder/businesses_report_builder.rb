module JsonReportBuilder
  module ExcelReport
    module Builder
      class BusinessesReportBuilder < Base
        DATA_START_ROW = 4

        def import(action_name, *args)
          args = args.extract_options!
          case action_name
          when 'index' then
            make_list(args[:businesses])
          end
        end

        private

        def make_list(businesses)
          @excel_object.template_file_name = "#{ Rails.root }/excel_templates/businesses.xlsx"

          sheet = SheetObject.new(
            template_sheet_name: 'template',
            output_sheet_name: '',
            new_name: '業務一覧'
          )
          @excel_object.sheets << sheet

          businesses.each_with_index do |business, idx|
            row = RowObject.new(row_index: DATA_START_ROW + idx, row_index_template: 4)
            row.cols << ColObject.new(col_index:  0, value: idx + 1, type: ColObject::TYPE_DOUBLE)
            row.cols << ColObject.new(col_index:  1, value: business.code)
            row.cols << ColObject.new(col_index:  2, value: business.name)
            row.cols << ColObject.new(col_index:  3, value: "#{ business.financial_start_year } 期")
            row.cols << ColObject.new(col_index:  4, value: business.contract_constructions.size, type: ColObject::TYPE_DOUBLE)
            sheet.rows << row
          end
        end
      end
    end
  end
end
