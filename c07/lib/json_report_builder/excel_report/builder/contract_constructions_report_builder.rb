module JsonReportBuilder
  module ExcelReport
    module Builder
      class ContractConstructionsReportBuilder < Base
        DATA_START_ROW = 3

        def import(action_name, *args)
          args = args.extract_options!
          case action_name
          when 'index' then
            make_list(args[:contract_constructions])
          end
        end

        private

        def make_list(contract_constructions)
          @excel_object.template_file_name = "#{ Rails.root }/excel_templates/contract_constructions.xlsx"

          sheet = SheetObject.new(
            template_sheet_name: 'template',
            output_sheet_name: 'data'
          )
          @excel_object.sheets << sheet

          sheet.rows << RowObject.new(row_index: 0, row_index_template: 0)
          sheet.rows << RowObject.new(row_index: 1, row_index_template: 1)
          sheet.rows << RowObject.new(row_index: 2, row_index_template: 2)

          make_list_data(sheet: sheet, contract_constructions: contract_constructions)
        end

        def make_list_data(sheet:, contract_constructions:)
          row_count = 0
          prev_business_code = ''
          total_count = 0
          total_amount = 0
          contract_constructions.each do |financial_year, financial_year_contract_constructions|
            financial_count = 0
            financial_amount = 0
            # 決算期ごとのデータ
            financial_year_contract_constructions.each do |contract_construction|
              # 明細データ作成
              unless contract_construction.business.code == prev_business_code
                sheet.rows << RowObject.new(row_index: DATA_START_ROW + row_count, row_index_template: 3)
                row_count += 1
              end
              row = RowObject.new(row_index: DATA_START_ROW + row_count, row_index_template: 4)
              row.cols << ColObject.new(col_index:  0, value: contract_construction.financial_year)
              row.cols << ColObject.new(col_index:  1, value: contract_construction.business.code)
              row.cols << ColObject.new(col_index:  2, value: contract_construction.code)
              row.cols << ColObject.new(col_index:  3, value: contract_construction.construction_info.customer_company.try(:name))
              row.cols << ColObject.new(col_index:  4, value: contract_construction.name)
              row.cols << ColObject.new(col_index:  5, value: contract_construction.quotation.try(:no))
              row.cols << ColObject.new(col_index:  6, value: contract_construction.decision_no)
              # row.cols << ColObject.new(col_index:  7, value: contract_construction.name)
              # row.cols << ColObject.new(col_index:  8, value: contract_construction.name)
              row.cols << ColObject.new(col_index:  9, value: contract_construction.construction_info.master_construction_model.try(:name))
              row.cols << ColObject.new(col_index: 10, value: contract_construction.technical_employee.try(:name))
              amount = contract_construction.decision_amount.present? ? contract_construction.decision_amount : contract_construction.construction_info.expected_amount
              row.cols << ColObject.new(col_index: 11, value: amount.to_i, type: ColObject::TYPE_DOUBLE)
              sheet.rows << row

              prev_business_code = contract_construction.business.code
              financial_count += 1
              financial_amount += amount
              row_count += 1
            end
            # 決算合計
            sheet.rows << RowObject.new(row_index: DATA_START_ROW + row_count, row_index_template: 3)
            row_count += 1

            row = RowObject.new(row_index: DATA_START_ROW + row_count, row_index_template: 5)
            row.cols << ColObject.new(col_index:  7, value: "#{ financial_year }期")
            row.cols << ColObject.new(col_index:  9, value: financial_count, type: ColObject::TYPE_DOUBLE)
            row.cols << ColObject.new(col_index: 11, value: financial_amount, type: ColObject::TYPE_DOUBLE)
            sheet.rows << row

            total_count += financial_count
            total_amount += financial_amount
            row_count += 1
          end
          # 総合計
          sheet.rows << RowObject.new(row_index: DATA_START_ROW + row_count, row_index_template: 6)
          row_count += 1

          row = RowObject.new(row_index: DATA_START_ROW + row_count, row_index_template: 7)
          row.cols << ColObject.new(col_index:  9, value: total_count, type: ColObject::TYPE_DOUBLE)
          row.cols << ColObject.new(col_index: 11, value: total_amount, type: ColObject::TYPE_DOUBLE)
          sheet.rows << row
        end
      end
    end
  end
end
