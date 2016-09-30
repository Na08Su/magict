class MasterBankBranchesController < ApplicationController
  before_action :find_master_bank, only: [:index, :new]
  before_action :find_master_bank_branch, only: [:edit, :update, :destroy]

  def index
    @query = @master_bank.master_bank_branches.search(search_params)
    @master_bank_branches = @query.result.page(params[:page]).per(Settings.per_page).order(code: :asc)
  end

  def new
    @master_bank_branch = @master_bank.master_bank_branches.build
  end

  def create
    @master_bank_branch = MasterBankBranch.new(master_bank_branch_params)
    if @master_bank_branch.save
      redirect_to master_bank_master_bank_branches_path(master_bank_id: @master_bank_branch.master_bank_code),
        flash: { notice: t('action.created', model_name: MasterBankBranch.model_name.human, name: @master_bank_branch.name) }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @master_bank_branch.update(master_bank_branch_params)
      redirect_to master_bank_master_bank_branches_path(master_bank_id: @master_bank_branch.master_bank_code),
        flash: { notice: t('action.updated', model_name: MasterBankBranch.model_name.human, name: @master_bank_branch.name) }
    else
      render :edit
    end
  end

  def destroy
    if @master_bank_branch.destroy
      redirect_to master_bank_master_bank_branches_path(master_bank_id: @master_bank_branch.master_bank_code),
        flash: { notice: t('action.deleted', model_name: MasterBankBranch.model_name.human, name: @master_bank_branch.name) }
    else
      render :edit
    end
  end

  private

  def search_params
    return {} if params[:q].blank?
    params.require(:q)
          .permit(:code_eq, :name_cont)
  end

  def master_bank_branch_params
    params.require(:master_bank_branch).permit(:code, :name, :name_kana, :master_bank_code)
  end

  def find_master_bank
    @master_bank = MasterBank.find(params[:master_bank_id])
  end

  def find_master_bank_branch
    @master_bank_branch = MasterBankBranch.find(params[:id])
  end
end
