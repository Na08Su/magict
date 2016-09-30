module JsonReportBuilder
  module ExcelReport
    module Builder
      class ConstructionInfosReportBuilder < Base
        DATA_START_ROW_INDEX = 3
        IN_SCHEDULE_MARK_COL_INDEX = 15
        COL_ALPHABETS = %w(P Q R S T U V W X Y Z AA).freeze

        def import(action_name, *args)
          args = args.extract_options!
          case action_name
          when 'expect_order_list' then
            make_expect_order_list(construction_infos: args[:construction_infos], order_by_probability: args[:order_by_probability])
          end
        end

        private

        def make_expect_order_list(construction_infos:, order_by_probability:)
          @excel_object.template_file_name = "#{ Rails.root }/excel_templates/construction_infos_expect_order_list.xlsx"

          sheet = SheetObject.new(
            template_sheet_name: 'template',
            output_sheet_name: 'data',
            new_name: '受注予定一覧',
            print_col_index_start: 0,
            print_col_index_end: IN_SCHEDULE_MARK_COL_INDEX + COL_ALPHABETS.size - 1,
            print_row_index_start: 0
          )
          @excel_object.sheets << sheet

          sheet.rows << RowObject.new(row_index: 0, row_index_template: 0)
          sheet.rows << RowObject.new(row_index: 1, row_index_template: 1)
          row = RowObject.new(row_index: 2, row_index_template: 2)
          this_month_first = Time.current.beginning_of_month
          12.times do |t|
            row.cols << ColObject.new(col_index:  15 + t, value: (this_month_first + t.months).end_of_month, type: ColObject::TYPE_DATE)
          end
          sheet.rows << row

          make_expect_order_list_data(sheet: sheet, construction_infos: construction_infos, order_by_probability: order_by_probability)
        end

        def make_expect_order_list_data(sheet:, construction_infos:, order_by_probability:)
          row_count = 0
          number = 1
          total_expected_amount = 0

          construction_infos.each do |group_id, group_construction_infos|
            group_construction_infos.each do |construction_info|
              make_expect_order_list_construction_info(sheet: sheet, row_index: DATA_START_ROW_INDEX + row_count, number: number, construction_info: construction_info)
              row_count += 1
              number += 1
            end
            # 小計
            row_index = DATA_START_ROW_INDEX + row_count
            row = RowObject.new(row_index: row_index, row_index_template: 6)

            code = order_by_probability ? MasterConstructionProbability.find_by(id: group_id).try(:code) : MasterConstructionModel.find_by(id: group_id).try(:name)
            row.cols << ColObject.new(col_index:  0, value: code + '      小   計')

            expected_amount = group_construction_infos.sum { |c| c.expected_amount.to_i }
            total_expected_amount += expected_amount
            row.cols << ColObject.new(col_index:  7, value: expected_amount, type: ColObject::TYPE_DOUBLE)

            sheet.rows << row
            sheet.merges << MergeObject.new(start_row_index: row_index, start_col_index: 0, end_row_index: row_index, end_col_index: 6)
            row_count += 1
          end
          row_index = DATA_START_ROW_INDEX + row_count
          row = RowObject.new(row_index: row_index, row_index_template: 8)
          row.cols << ColObject.new(col_index:  7, value: total_expected_amount, type: ColObject::TYPE_DOUBLE)
          sheet.rows << row
          sheet.merges << MergeObject.new(start_row_index: row_index, start_col_index: 0, end_row_index: row_index, end_col_index: 6)

          sheet.print_row_index_end = row_index
        end

        def make_expect_order_list_construction_info(sheet:, row_index:, number:, construction_info:)
          construction_info = ActiveDecorator::Decorator.instance.decorate(construction_info)
          row = RowObject.new(row_index: row_index, row_index_template: 4)

          row.cols << ColObject.new(col_index:  0, value: number)
          row.cols << ColObject.new(col_index:  1, value: construction_info.financial_year)
          row.cols << ColObject.new(col_index:  2, value: construction_info.master_construction_probability.try(:code))
          row.cols << ColObject.new(col_index:  3, value: construction_info.quotation.try(:no))
          row.cols << ColObject.new(col_index:  4, value: construction_info.site_name)
          row.cols << ColObject.new(col_index:  5, value: construction_info.construction_name)
          row.cols << ColObject.new(col_index:  6, value: construction_info.master_construction_model.try(:name))
          row.cols << ColObject.new(col_index:  7, value: construction_info.expected_amount, type: ColObject::TYPE_DOUBLE)
          row.cols << ColObject.new(col_index:  8, value: construction_info.customer_company.try(:name))
          row.cols << ColObject.new(col_index:  9, value: construction_info.building_contractor)
          row.cols << ColObject.new(col_index: 10, value: construction_info.foreman_employee.try(:name))
          row.cols << ColObject.new(col_index: 11, value: construction_info.sales_employee.try(:name))
          row.cols << ColObject.new(col_index: 12, value: construction_info.schedule_start, type: ColObject::TYPE_DATE)
          row.cols << ColObject.new(col_index: 14, value: construction_info.schedule_end, type: ColObject::TYPE_DATE)
          12.times do |t|
            row.cols << col_object_in_schedule_mark(col_index: IN_SCHEDULE_MARK_COL_INDEX + t, row_index: row_index)
          end
          sheet.rows << row
        end

        def col_object_in_schedule_mark(col_index:, row_index:)
          header_cell = "#{ COL_ALPHABETS[col_index - IN_SCHEDULE_MARK_COL_INDEX] }3"
          row_num = row_index + 1
          and_in = "AND(M#{ row_num }<=#{ header_cell },O#{ row_num }>=#{ header_cell })"
          and_year_month = "AND(YEAR(O#{ row_num })=YEAR(#{ header_cell }),MONTH(O#{ row_num })=MONTH(#{ header_cell }))"
          value = "IF(OR(#{ and_in },#{ and_year_month })," + '"]]]]]]]]]","")'
          ColObject.new(col_index: col_index, value: value, type: ColObject::TYPE_FORMULA)
        end
      end
    end
  end
end
