class RegularDebitAccountsController < ApplicationController
  before_action :find_regular_debit_account, only: [:edit, :update, :destroy]

  def index
    @query = current_company.regular_debit_accounts.search(search_params)
    @regular_debit_accounts = @query.result.with_deleted.page(params[:page]).per(Settings.per_page).order(withdrawal_day: :asc)

    @total_price = current_company.regular_debit_accounts.to_a.sum { |payment| payment.payment_amount.to_i } # 合計
    @fixation_price = current_company.regular_debit_accounts.fixation.to_a.sum { |payment| payment.payment_amount.to_i } # 固定
    @remotion_price = current_company.regular_debit_accounts.remotion.to_a.sum { |payment| payment.payment_amount.to_i } # 移動
    @fluctuation_price = current_company.regular_debit_accounts.fluctuation.to_a.sum { |payment| payment.payment_amount.to_i } # 変動
  end

  def new
    @regular_debit_account = current_company.regular_debit_accounts.build
  end

  def create
    @regular_debit_account = current_company.regular_debit_accounts.build(regular_debit_account_params)
    if @regular_debit_account.save
      redirect_to regular_debit_accounts_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @regular_debit_account.update(regular_debit_account_params)
      redirect_to edit_regular_debit_account_path, flash: { notice: 'updated' }
    else
      render :edit
    end
  end

  def destroy_all
    checked_data = params[:deletes].keys
    if current_company.regular_debit_accounts.with_deleted.destroy(checked_data)
      redirect_to regular_debit_accounts_path
    else
      render action: 'index'
    end
  end

  def destroy
    if @regular_debit_account.destroy
      redirect_to regular_debit_accounts_path, flash: { notice: 'deleted' }
    else
      render :edit
    end
  end

  private

  def find_regular_debit_account
    @regular_debit_account = current_company.regular_debit_accounts.with_deleted.find(params[:id])
  end

  def regular_debit_account_params
    params.require(:regular_debit_account)
    .permit(:drawer_type, :withdrawal_month, :withdrawal_day, :payment_content, :payment_content_detail, :payment_amount, :control_trading_account_id)
  end

  def search_params
    return {} if params[:q].blank?
    params.require(:q)
          .permit(:withdrawal_month_cont, :payment_content_cont)
  end
end
