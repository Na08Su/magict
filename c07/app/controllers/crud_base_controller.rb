#
# 基本的なCRUDを提供する為のコントローラー
# resource_klass(Class), resource_params(Method)を必ず定義する.
#
# usage:
#   class HogeController < CrndBaseController
#     resource_klass Hoge
#     resource_params :hoge_params
#     resource_crnd_options index_order_by: :code, flash_message_attribute: :short_name
#
class CrudBaseController < ApplicationController
  include ResourceDetector

  before_action :find_resource, only: [:edit, :update, :destroy]

  def index
    @query = resource_klass.search(search_params)
    instance_variable_set("@#{ resources_name }", @query.result.order(resources_order_by).page(params[:page]).per(Settings.per_page))
  end

  def new
    instance_variable_set("@#{ resource_name }", resource_klass.new)
  end

  def create
    instance_variable_set("@#{ resource_name }", resource_klass.new(resource_params))
    if resource_object.save
      redirect_to({ action: :index }, flash: { notice: t('action.created', model_name: resource_klass.model_name.human, name: resource_object.send(flash_message_attribute)) })
    else
      render :new
    end
  end

  def update
    if resource_object.update(resource_params)
      redirect_to({ action: :index }, flash: { notice: t('action.updated', model_name: resource_klass.model_name.human, name: resource_object.send(flash_message_attribute)) })
    else
      render :edit
    end
  end

  def destroy
    if resource_object.destroy
      redirect_to({ action: :index }, flash: { notice: t('action.deleted', model_name: resource_klass.model_name.human, name: resource_object.name) })
    else
      render :edit
    end
  end

  private

  def search_params
    Rails.logger.warn('--- Please define search_params method! ---')
    {}
  end
end
