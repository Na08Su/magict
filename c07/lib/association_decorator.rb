module AssociationDecorator
  def reader(*args)
    result = super
    if owner.is_a?(ActiveDecorator::Helpers)
      ActiveDecorator::Decorator.instance.decorate(result)
    end
    result
  end
end
