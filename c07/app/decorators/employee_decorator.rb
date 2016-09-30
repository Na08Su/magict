module EmployeeDecorator
  def full_name
    "#{ lastname }#{ firstname }"
  end
  alias name full_name

  def code_with_name
    code.blank? ? full_name : "#{ code }:#{ full_name }"
  end
end
