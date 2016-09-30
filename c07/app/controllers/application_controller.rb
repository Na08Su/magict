class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  helper_method :current_company
  helper_method :current_tax_rate

  def current_company
    @_current_company ||= current_user.try(:company)
  end

  def current_financial_year
    # FIXME: 企業設定から取得するように修正する
    32
  end

  def current_tax_rate
    # FIXME: 企業設定から取得するように修正する
    0.08
  end

  private

  def configure_tax_rate_to_gon
    gon.tax_rate = current_tax_rate
  end

  def configure_costs_to_gon
    gon.costs = current_company.costs
  end
end
