module CompanyDecorator
  def full_address
    "#{ prefecture.name }#{ address1 }#{ address2 }#{ address3 }"
  end
end
