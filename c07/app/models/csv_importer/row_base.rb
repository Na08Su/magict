module CsvImporter
  class RowBase
    include Virtus.model

    attr_accessor :object # instance化したModelオブジェクトを入れる
    attr_accessor :index  # 行番号

    # some attributes add
    # ex.
    # attribute :hoge, Integer
    # attribute :fuga, String

    def build_object(klass)
      obj = klass.new
      obj.assign_attributes(to_hash)
      obj.valid?
    rescue ArgumentError => e # enumのerrorを拾う
      obj.errors.add(:base, e.message)
    ensure
      self.object = obj
      obj
    end

    def error?
      object.nil? || object.errors.any?
    end

    def error_message
      object.errors.full_messages.join(' ')
    end
  end
end
