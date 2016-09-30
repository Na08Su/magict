class CompanyRelationsController < ApplicationController
  before_action :find_company_relation, only: [:edit, :update, :destroy]
  before_action :set_ransack_query, only: [:index, :export_excel]

  def index
    @company_relations = search_result.page(params[:page]).per(Settings.per_page)
  end

  def export_excel
    builder = JsonReportBuilder::ExcelReport::Builder::CompanyRelationsReportBuilder.new
    builder.import('index', company_relations: search_result)
    output_file_name = JsonReportBuilder.create(tmp_file_name: controller_name, builder: builder, separate: current_user.id.to_s)
    send_file(output_file_name)
  rescue => e
    @company_relations = search_result.page(params[:page]).per(Settings.per_page)
    flash.now[:alert] = e.message
    render :index
  end

  def new
    @company_relation = current_user.company.own_company_relations.build
    @company_relation.customer = @company_relation.build_customer
    @company_relation.payee = @company_relation.build_payee
    @company_relation.vendor = @company_relation.build_vendor
  end

  def create
    @company_relation = current_user.company.own_company_relations.build(company_relation_params)
    if @company_relation.save
      redirect_to company_relations_path, flash: {
        notice: t('action.created',
        model_name: @company_relation.model_name.human,
        name: "#{ @company_relation.code }:#{ @company_relation.partner_company.name }")
      }
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @company_relation.update(company_relation_params)
      redirect_to edit_company_relation_path(@company_relation), flash: { notice: 'updated!!' }
    else
      render 'edit'
    end
  end

  def destroy
    if @company_relation.destroy
      redirect_to company_relations_path, flash: { notice: 'deleted!!' }
    else
      render 'edit'
    end
  end

  private

  def find_company_relation
    @company_relation = current_user.company.own_company_relations.find(params[:id])
  end

  def search_params
    return {} if params[:q].blank?
    params.require(:q)
          .permit(:code_start, :partner_company_name_cont).to_h
  end

  def company_relation_params
    params.require(:company_relation).permit(
      :partner_company_id, :code, :own_company_code, :contact_person, :contact_tel, :contact_fax,
      :basic_contract_day, :start_up_date, :recital1, :recital2,
      :customer_flag, :payee_flag, :vendor_flag,
      customer_attributes: [
        :category, :cutoff_date, :cutoff_date_cycle, :arrival_day_of_submittal,
        :receipt_date, :receipt_account_code, :draft_site, :receipt_term
      ],
      payee_attributes: [
        :cutoff_date, :payment_account, :payment_check, :payment_cash, :payment_note_payable,
        :draft_site, :payment_notice, :master_bank_branch_id, :bank_account_type,
        :bank_account_number, :bank_account_name, :bank_account_name_kana
      ],
      vendor_attributes: [
        :category, :payee_id, :account_heading_id
      ]
    )
  end

  def set_ransack_query
    @query = current_user.company.own_company_relations
    @query = @query.send(params[:classification]) if %w(customers vendors payees).member?(params[:classification])
    @query = @query.search(search_params)
  end

  def search_result
    @query.result.order(code: :asc)
  end
end
