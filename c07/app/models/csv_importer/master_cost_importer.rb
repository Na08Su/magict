module CsvImporter
  class MasterCostImporter < Base
    def execute
      rows = []

      open_csv do |csv|
        csv.each.with_index(1) do |row, index|
          next if row.header_row?

          attributes = Hash[[row.headers.map(&:to_sym), row.fields].transpose]
          row = Row.new(attributes)

          begin
            object = caches[attributes[unique_key].to_i] || klass.new
            object.assign_attributes(row.to_hash)
            object.valid?
          rescue ArgumentError => e # enumのerrorを拾う
            object.errors.add(:base, e.message)
          end

          row.index = index
          row.object = object
          rows << row
        end
      end

      import(rows) if rows.present?
      rows.size
    end

    def klass
      Cost
    end

    class Row < RowBase
      attribute :code,         Integer
      attribute :name,         String
      attribute :cost_class,   Integer
      attribute :budget_class, Integer
    end
  end
end
