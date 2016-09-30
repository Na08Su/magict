module MasterDataCacheable
  extend ActiveSupport::Concern

  module ClassMethods
    def all_cache
      @all_cache ||= all.to_a
    end

    def indexed_cache
      @indexed_cache ||= all.index_by(&:id)
    end

    def clear_cache
      @all_cache = nil
      @indexed_cache = nil
    end

    def reload_cache
      clear_cache
      all_cache
    end

    def find_cache_by(options)
      return nil unless options.is_a? Hash
      all_cache.find { |record| options.all? { |k, v| record[k] == v } }
    end

    def select_cache_by(options)
      return nil unless options.is_a? Hash
      all_cache.select do |record|
        options.all? do |k, v|
          if enum_values = defined_enums[k.to_s]
            v.is_a?(Numeric) ? record[k] == v : record[k] == enum_values[v.to_s]
          elsif column_names.include?(k.to_s)
            record[k] == v
          else
            record.send(k) == v
          end
        end
      end
    end
  end
end
