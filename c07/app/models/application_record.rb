class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # postgres 数値 -> 文字列用 to_char format
  TO_CHAR_FORMAT = 'FM999999999999999999'.freeze
end
