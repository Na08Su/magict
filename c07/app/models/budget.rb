class Budget < ApplicationRecord
  belongs_to :contract_construction
  has_many :budget_costs, inverse_of: :budget

  delegate :quotation, to: :contract_construction

  accepts_nested_attributes_for :budget_costs, allow_destroy: true

  before_create :build_no

  validate :same_cost_do_not_regist

  def total_amount_ratio
    return nil if total_amount.zero? || contract_construction.decision_amount.blank?
    ((total_amount / contract_construction.decision_amount.to_f) * 100).round(1)
  end

  def total_final_amount_ratio
    return nil if total_final_amount.zero? || contract_construction.decision_amount.blank?
    ((total_final_amount / contract_construction.decision_amount.to_f) * 100).round(1)
  end

  # 見積の金額を実行予算額へコピーをする
  # すでに登録されている原価で同じコード値のものがあれば無視する
  # FIXME: 経費率
  def costs_reflect_from_quotation
    contract_construction.quotation.quotation_details.group_by(&:cost_id).each do |cost_id, details|
      details = details.map { |d| ActiveDecorator::Decorator.instance.decorate(d) }

      budget_cost = budget_costs.detect { |bc| bc.cost_id == cost_id } || budget_costs.build(cost_id: cost_id)
      budget_cost.assign_attributes(quotation_submitted_amount: details.sum(&:submitted_amount), quotation_initial_cost_amount: details.sum(&:initial_cost_amount))
    end
  end

  private

  # TODO: 内部発注工事、配管工事の場合を考慮すべきか
  def build_no
    maximum_no = Budget.maximum(:no)
    self[:no] = format('%05d', (maximum_no.to_i + 1))
  end

  def same_cost_do_not_regist
    budget_costs.group_by(&:cost_id).each do |_, costs|
      if costs.size > 1
        cost = ActiveDecorator::Decorator.instance.decorate(costs.first.cost)
        errors.add(:base, I18n.t('errors.messages.same_cost_do_not_regist', cost: cost.code_with_name))
      end
    end
  end
end
