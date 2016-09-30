module JsonReportBuilder
  module ExcelReport
    module Builder
      class ReportOfBusinessesReportBuilder < Base
        DATA_START_ROW = 4
        MODEL_START_COL = 3
        FIRST_COPY_ROW_INDEX = 4
        AMONG_COPY_ROW_INDEX = 5
        SECOND_COPY_ROW_INDEX = 7

        def import(action_name, *args)
          args = args.extract_options!
          case action_name
          when 'construction_summary' then
            make_construction_summary(args[:construction_summary])
          end
        end

        private

        def make_construction_summary(construction_summary)
          @excel_object.template_file_name = "#{ Rails.root }/excel_templates/construction_summary.xlsx"

          sheet = SheetObject.new(
            template_sheet_name: 'template',
            output_sheet_name: 'data'
          )
          @excel_object.sheets << sheet

          sheet.rows << RowObject.new(row_index: 0, row_index_template: 0)
          sheet.rows << RowObject.new(row_index: 1, row_index_template: 1)
          sheet.rows << RowObject.new(row_index: 2, row_index_template: 2)
          row = RowObject.new(row_index: 3, row_index_template: 3)
          construction_summary.master_construction_models.each_with_index do |master_construction_model, idx|
            row.cols << ColObject.new(col_index:  MODEL_START_COL + idx, value: master_construction_model.name, copy_row_index: 3, copy_col_index: MODEL_START_COL)
          end
          row.cols << ColObject.new(
            col_index:  MODEL_START_COL + construction_summary.master_construction_models.size,
            value: '合計',
            copy_row_index: 3,
            copy_col_index: MODEL_START_COL + 1
          )
          sheet.rows << row

          copy_row_index = FIRST_COPY_ROW_INDEX
          construction_summary.rows.each_with_index do |row_summary, idx|
            case row_summary.mode
            when 0
              make_construction_summary_data(sheet: sheet, row_summary: row_summary, idx: idx, copy_row_index: copy_row_index)
              # データの次は、期の間のデータ行
              copy_row_index = AMONG_COPY_ROW_INDEX
            when 1
              make_construction_summary_sub_total(sheet: sheet, row_summary: row_summary, idx: idx)
              # 小計の次は、期の受注予定最初のデータ行
              copy_row_index = SECOND_COPY_ROW_INDEX
            when 2
              make_construction_summary_total(sheet: sheet, row_summary: row_summary, idx: idx)
              # 合計の次は、期の最初のデータ行
              copy_row_index = FIRST_COPY_ROW_INDEX
            end
          end
        end

        def make_construction_summary_data(sheet:, row_summary:, idx:, copy_row_index:)
          row = RowObject.new(row_index: DATA_START_ROW + idx, row_index_template: copy_row_index)
          row.cols << ColObject.new(col_index: 0, value: row_summary.financial_year)
          row.cols << ColObject.new(col_index: 1, value: row_summary.kind_name)
          row.cols << ColObject.new(col_index: 2, value: row_summary.construction_probability_name)
          row_summary.amounts.each_with_index do |amount, index|
            row.cols << ColObject.new(
              col_index: MODEL_START_COL + index,
              value: amount,
              copy_row_index: copy_row_index,
              copy_col_index: MODEL_START_COL,
              type: ColObject::TYPE_DOUBLE
            )
          end
          row.cols << ColObject.new(
            col_index: MODEL_START_COL + row_summary.amounts.size,
            value: row_summary.total_amount,
            copy_row_index: copy_row_index,
            copy_col_index: MODEL_START_COL + 1,
            type: ColObject::TYPE_DOUBLE
          )
          sheet.rows << row
        end

        def make_construction_summary_sub_total(sheet:, row_summary:, idx:)
          row = RowObject.new(row_index: DATA_START_ROW + idx, row_index_template: 6)
          row_summary.amounts.each_with_index do |amount, index|
            row.cols << ColObject.new(
              col_index: MODEL_START_COL + index,
              value: amount,
              copy_row_index: 6,
              copy_col_index: MODEL_START_COL,
              type: ColObject::TYPE_DOUBLE
            )
          end
          row.cols << ColObject.new(
            col_index: MODEL_START_COL + row_summary.amounts.size,
            value: row_summary.total_amount,
            copy_row_index: 6,
            copy_col_index: MODEL_START_COL + 1,
            type: ColObject::TYPE_DOUBLE
          )
          sheet.rows << row
        end

        def make_construction_summary_total(sheet:, row_summary:, idx:)
          row_index = DATA_START_ROW + idx
          row = RowObject.new(row_index: row_index, row_index_template: 8)
          row_summary.amounts.each_with_index do |amount, index|
            row.cols << ColObject.new(
              col_index: MODEL_START_COL + index,
              value: amount,
              copy_row_index: 8,
              copy_col_index: MODEL_START_COL,
              type: ColObject::TYPE_DOUBLE
            )
          end
          row.cols << ColObject.new(
            col_index: MODEL_START_COL + row_summary.amounts.size,
            value: row_summary.total_amount,
            copy_row_index: 8,
            copy_col_index: MODEL_START_COL + 1,
            type: ColObject::TYPE_DOUBLE
          )
          sheet.rows << row
          sheet.merges << MergeObject.new(
            start_col_index: 1,
            start_row_index: row_index,
            end_col_index: 2,
            end_row_index: row_index
          )
        end
      end
    end
  end
end
