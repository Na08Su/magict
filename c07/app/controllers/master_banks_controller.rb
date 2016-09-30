class MasterBanksController < CrudBaseController
  resource_klass MasterBank
  resource_params :master_bank_params

  def index
    @query = resource_klass.search(search_params)
    @master_banks = @query.result.includes(:master_bank_branches).order(code: :asc).page(params[:page]).per(Settings.per_page)
  end

  private

  def search_params
    return {} if params[:q].blank?
    params.require(:q).permit(:code_eq, :name_cont).to_h
  end

  def master_bank_params
    params.require(:master_bank).permit(:code, :name, :name_kana)
  end
end
