module BusinessDecorator
  def attributes_for_modal
    {
      id: id,
      code: code,
      name: name,
      next_construction_code: next_construction_code
    }
  end
end
