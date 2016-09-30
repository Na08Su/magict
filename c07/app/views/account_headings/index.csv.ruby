require 'csv'

header = @account_headings.attribute_names
csv_data = CSV.generate('', headers: header, write_headers: true) do |csv|
  @account_headings.each do |data|
    csv << data.attributes.values
  end
end.gsub("\u00A5", "\\").encode('cp932')
