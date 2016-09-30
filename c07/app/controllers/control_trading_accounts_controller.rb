class ControlTradingAccountsController < ApplicationController
  before_action :find_control, only: [:edit, :update, :destroy]

  def index
    @query = current_company.control_trading_accounts.search(search_params)
    @control_trading_accounts = @query.result.page(params[:page]).per(Settings.per_page).order(bank_code: :asc)
  end

  def new
    @control_trading_account = current_company.control_trading_accounts.build
  end

  def create
    @control_trading_account = current_company.control_trading_accounts.build(control_trading_account_params)
    if @control_trading_account.save
      redirect_to control_trading_accounts_path,
      flash: { notice: t('action.created', model_name: ControlTradingAccount.model_name.human, name: @control_trading_account.bank_short_name) }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @control_trading_account.update(control_trading_account_params)
      redirect_to edit_control_trading_account_path,
      flash: { notice: t('action.updated', model_name: ControlTradingAccount.model_name.human, name: @control_trading_account.bank_short_name) }
    else
      render :edit
    end
  end

  def destroy
    if @control_trading_account.destroy
      redirect_to control_trading_accounts_path,
      flash: { notice: t('action.deleted', model_name: ControlTradingAccount.model_name.human, name: @control_trading_account.bank_short_name) }
    else
      render :edit
    end
  end

  private

  def find_control
    @control_trading_account = current_company.control_trading_accounts.find(params[:id])
  end

  def search_params
    return {} if params[:q].blank?
    params.require(:q)
          .permit(:bank_code_cont, :bank_branch_code_cont)
  end

  def control_trading_account_params
    params.require(:control_trading_account)
    .permit(:bank_code, :bank_branch_code, :account_number, :account_name, :account_name_kana, :bank_short_name, :account_headings, :limit_borrowing)
  end
end
