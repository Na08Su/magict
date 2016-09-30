require 'csv'

header = @master_costs.attribute_names
csv_data = CSV.generate('', headers: header, write_headers: true) do |csv|
  @master_costs.each do |data|
    csv << data.attributes.values
  end
end.gsub("\u00A5", "\\").encode('cp932')
