module CsvImporter
  class QuotationDetailImporter < Base
    SPACE_REGEXP = /[[:space:]]/

    # not_attributeは取り込みを行わない
    CSV_HEADERS = [
      :not_attribute1,        # 種別
      :not_attribute2,        # 工事番号
      :paragraph,             # 項
      :name1,                 # 名称1
      :name2,                 # 名称2
      :unit,                  # 単位
      :submitted_quantity,    # 提出数量
      :submitted_price,       # 提出単価
      :not_attribute4,        # 提出金額
      :initial_cost_quantity, # 原価数量
      :initial_cost_price,    # 原価単価
      :not_attribute5,        # 原価金額
      :not_attribute6,        # 歩掛1
      :not_attribute7,        # 歩掛2
      :not_attribute8,        # 歩掛3
      :not_attribute9,        # 工数1
      :not_attribute10,       # 工数2
      :not_attribute11,       # 工数3
      :not_attribute12,       # 備考
      :not_attribute13,       # 支給品名称
      :not_attribute14        # 撤去名称
    ].freeze

    def execute
      rows = []
      quotation = @options[:quotation]

      open_csv do |csv|
        csv.each.with_index(1) do |row, index|
          next if row.header_row?

          # FIXME: 合計行を除く
          attributes = Hash[[CSV_HEADERS, row.fields].transpose]
          attributes[:row_level] = row_level(attributes)
          attributes[:quotation_id] = quotation.id if attributes[:row_level].to_i == QuotationDetail.row_levels[:title]
          attributes.delete(:paragraph)

          # 項番が設定されていない場合は設定(最初の行にのみ、項番が設定されている想定)
          # paragraph = attributes[:paragraph].strip if !paragraph && attributes[:paragraph].present?

          row = Row.new(attributes)
          row.build_object(klass)
          row.index = index
          rows << row

          add_detail_to_quotation(quotation: quotation, object: row.object)
        end
      end

      errors = rows.select(&:error?)
      fail RowInvalid, errors.map { |row| "#{ row.index }行目: #{ row.error_message }" }.join('<br />') if errors.present?

      quotation.save!
    end

    private

    def klass
      QuotationDetail
    end

    def row_level(attributes)
      if attributes[:paragraph].present?
        QuotationDetail.row_levels[:title]
      elsif attributes[:name1] && attributes[:name1].match(SPACE_REGEXP)
        QuotationDetail.row_levels[:detail]
      else
        QuotationDetail.row_levels[:sub_title]
      end
    end

    def add_detail_to_quotation(quotation:, object:)
      quotation.quotation_details << object
    end

    class Row < RowBase
      attribute :quotation_id,          Integer
      attribute :row_level,             Integer
      attribute :name1,                 String
      attribute :name2,                 String
      attribute :unit,                  String
      attribute :submitted_quantity,    Integer
      attribute :submitted_price,       Integer
      attribute :initial_cost_quantity, Integer
      attribute :initial_cost_price,    Integer

      def name1=(value)
        super trim_space(value)
      end

      def name2=(value)
        super trim_space(value)
      end

      def unit=(value)
        super trim_space(value)
      end

      def trim_space(value)
        value.gsub(SPACE_REGEXP, '')
      end
    end
  end
end
