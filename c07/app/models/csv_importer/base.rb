require 'csv'

module CsvImporter
  class FileInvalid < StandardError; end
  class RowInvalid  < StandardError; end

  class Base
    include ActiveSupport::Callbacks

    ENCODING = 'r:cp932:utf-8'.freeze

    define_callbacks :open_csv
    set_callback :open_csv, :before, :valid_file?

    # @param [Hash] options インポートに使用するオプション
    # @option otpions [Symbol] :unique_key    行を特定する為のユニークなkey(default: :code)
    # @option options [Hash]   :file_options   ファイルオープン時に渡すオプション
    # @option options [Hash]   :csv_options    CSVオープン時に渡すオプション
    def initialize(file:, options: {})
      @file    = file
      @options = options
    end

    def execute
      fail NotImplementedError
    end

    private

    def klass
      fail NotImplementedError
    end

    def caches
      @_caches ||= klass.all.index_by(&:code)
    end

    def unique_key
      key = @options[:unique_key] || :code
      key.is_a?(Array) ? key : [key]
    end

    def file_options
      (@options[:file_options] || {}).reverse_merge!(undef: :replace)
    end

    def csv_options
      (@options[:csv_options] || {}).reverse_merge!(headers: :first_row)
    end

    def open_csv
      run_callbacks :open_csv do
        open(@file.path, ENCODING, file_options) do |f|
          csv = CSV.new(f, csv_options)
          yield(csv)
        end
      end
    end

    def valid_file?
      fail FileInvalid, I18n.t('errors.messages.not_selected_file') unless @file
      fail FileInvalid, I18n.t('errors.messages.only_csv_file') unless File.extname(@file.original_filename) == '.csv'
    end

    def import(rows)
      fail RowInvalid, rows.map { |row| "#{ row.index }行目: #{ row.error_message }" }.join('<br />') if rows.any?(&:error?)
      ActiveRecord::Base.transaction do
        # Postgresql9.5以上で、on_duplicate_key_updateが有効
        if ActiveRecord::Base.connection.postgresql_version >= 90500
          klass.import rows.map(&:object), on_duplicate_key_update: { conflict_target: unique_key, columns: rows.first.attributes.keys }, validate: false
        else
          rows.map(&:object).map { |o| o.save(validate: false) }
        end
      end
    end
  end
end
