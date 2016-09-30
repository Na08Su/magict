module DecorateGeneralFunctions
  extend ActiveSupport::Concern

  def code_with_name
    "#{ code } : #{ name }"
  end
end
