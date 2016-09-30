module JsonReportBuilder
  module ExcelReport
    module Builder
      class CompanyRelationsReportBuilder < Base
        def import(action_name, *args)
          args = args.extract_options!
          case action_name
          when 'index' then
            make_list(args[:company_relations])
          end
        end

        private

        def make_list(company_relations)
          @excel_object.template_file_name = "#{ Rails.root }/excel_templates/company_relations.xlsx"

          sheet = SheetObject.new(
            template_sheet_name: 'template1',
            output_sheet_name: 'data'
          )
          @excel_object.sheets << sheet

          sheet.rows << RowObject.new(row_index: 0, row_index_template: 0)
          sheet.merges << MergeObject.new(start_row_index: 0, start_col_index: 4, end_row_index: 0, end_col_index: 5)
          sheet.rows << RowObject.new(row_index: 1, row_index_template: 1)
          sheet.rows << RowObject.new(row_index: 2, row_index_template: 2)
          sheet.rows << RowObject.new(row_index: 3, row_index_template: 3)

          company_relations.each_with_index do |company_relation, idx|
            row = RowObject.new(row_index: 4 + idx, row_index_template: 4)
            row.cols << ColObject.new(col_index: 0, value: company_relation.code)
            partner_company = company_relation.partner_company
            ActiveDecorator::Decorator.instance.decorate(partner_company)
            row.cols << ColObject.new(col_index: 1, value: partner_company.name)
            row.cols << ColObject.new(col_index: 2, value: partner_company.full_address)
            mark = I18n.t('activerecord.attributes.company_relation.vendor_mark')
            row.cols << ColObject.new(col_index: 3, value: mark) if company_relation.customer?
            row.cols << ColObject.new(col_index: 4, value: mark) if company_relation.vendor?
            row.cols << ColObject.new(col_index: 5, value: mark) if company_relation.payee?

            sheet.rows << row
          end
        end
      end
    end
  end
end
