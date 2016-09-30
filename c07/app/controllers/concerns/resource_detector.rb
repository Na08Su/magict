module ResourceDetector
  extend ActiveSupport::Concern

  included do
    class_attribute :_resource_klass, :_resource_params, :_resource_crud_options
    self._resource_crud_options = HashWithIndifferentAccess.new
  end

  module ClassMethods
    def resource_klass(resource_klass)
      self._resource_klass = resource_klass
      _resource_klass
    end

    def resource_params(method_name)
      self._resource_params = method_name
      _resource_params
    end

    def resource_crud_options(options)
      self._resource_crud_options = options
      _resource_crud_options
    end
  end

  private

  def resource_klass
    _resource_klass
  end

  def resource_name
    _resource_klass.to_s.underscore
  end

  def resources_name
    resource_name.pluralize
  end

  def resource_object
    instance_variable_get("@#{ resource_name }")
  end

  def resource_params
    send(_resource_params)
  end

  def find_resource
    instance_variable_set("@#{ resource_name }", resource_klass.find(params[:id]))
  end

  def resources_order_by
    _resource_crud_options[:index_order_by] || :id
  end

  def flash_message_attribute
    _resource_crud_options[:flash_message_attribute] || :name
  end
end
