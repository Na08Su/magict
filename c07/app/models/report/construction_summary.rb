module Report
  class ConstructionSummary
    attr_reader :rows
    attr_reader :master_construction_models

    def initialize(current_company:, search_params:)
      @rows = []
      @master_construction_models = MasterConstructionModel.order(:code_order)
      @contract_construction_query = current_company.contract_constructions.search(search_params)
      @construction_info_query = current_company.construction_infos.search(search_params)
      setup_data
      make_rows
    end

    def q
      [@contract_construction_query, @construction_info_query]
    end

    private

    def setup_data
      @contract_constructions = @contract_construction_query.result.includes(construction_info: [:master_construction_model]).order(:financial_year)
      # すでに担当工事に昇格している営業工事は除く
      @construction_infos = @construction_info_query.result.includes(:master_construction_probability, :master_construction_model)
                            .order(:financial_year, :master_construction_probability_id).where.not(id: @contract_constructions.select(:construction_info_id))
    end

    def financial_years
      @_financial_years ||= [@contract_constructions, @construction_infos].map do |c|
        c.pluck(:financial_year)
      end.flatten.compact.uniq.sort_by
    end

    def make_rows
      financial_years.each do |financial_year|
        @financial_first = true
        @contract_model_amount = []
        @info_model_amount = []
        master_construction_models.each do |_|
          # 受注形態の数だけ初期化
          @contract_model_amount << 0
          @info_model_amount << 0
        end
        make_contract_rows(financial_year)
        make_info_rows(financial_year)
        make_total_row
      end
    end

    def make_contract_rows(financial_year)
      financial_order_status_contract_constructions = @contract_constructions.where(financial_year: financial_year)
        .order('order_status').group_by(&:order_status)
      if financial_order_status_contract_constructions.present?
        financial_order_status_contract_constructions.each do |order_status, financial_contract_constructions|
          row = Row.new
          financial_model_contract_constructions = financial_contract_constructions.group_by { |cc| cc.construction_info.master_construction_model }
          row.financial_year = @financial_first ? financial_year : ''
          row.kind_name = @financial_first ? '手持工事' : ''
          #row.construction_probability_name = I18n.t("enums.contract_construction.order_status.#{ order_status }")
          row.construction_probability_name = I18n.t(order_status, scope: [:enums, :contract_construction, :order_status])
          master_construction_models.each_with_index do |master_construction_model, idx|
            model_contract_constructions = financial_model_contract_constructions.select { |model| model == master_construction_model }
            constructions = model_contract_constructions[master_construction_model]
            row.amounts[idx] = constructions.present? ? constructions.to_a.sum { |cc| cc.try(:decision_amount).to_i } : 0
            @contract_model_amount[idx] += row.amounts[idx]
          end
          rows << row
          @financial_first = false
        end
        row = Row.new(mode: 1)
        row.construction_probability_name = '小計'
        master_construction_models.each_with_index do |_, idx|
          row.amounts[idx] = @contract_model_amount[idx]
        end
        rows << row
      end
    end

    def make_info_rows(financial_year)
      financial_probability_construction_infos = @construction_infos.where(financial_year: financial_year)
        .order(:master_construction_probability_id).group_by(&:master_construction_probability)
      if financial_probability_construction_infos.present?
        first = true
        financial_probability_construction_infos.each do |master_construction_probability, financial_construction_infos|
          row = Row.new
          financial_model_construction_infos = financial_construction_infos.group_by(&:master_construction_model)
          row.financial_year = @financial_first ? financial_year : ''
          row.kind_name = first ? '受注予定' : ''
          row.construction_probability_name = master_construction_probability.try(:name)
          master_construction_models.each_with_index do |master_construction_model, idx|
            model_construction_infos = financial_model_construction_infos.select { |model| model == master_construction_model }
            constructions = model_construction_infos[master_construction_model]
            row.amounts[idx] = constructions.present? ? constructions.to_a.sum { |ci| ci.try(:expected_amount).to_i } : 0
            @info_model_amount[idx] += row.amounts[idx]
          end
          rows << row
          @financial_first = false
          first = false
        end
        row = Row.new(mode: 1)
        master_construction_models.each_with_index do |_, idx|
          row.amounts[idx] = @info_model_amount[idx]
        end
        rows << row
      end
    end

    def make_total_row
      row = Row.new(mode: 2)
      master_construction_models.each_with_index do |_, idx|
        row.amounts[idx] = @contract_model_amount[idx] + @info_model_amount[idx]
      end
      rows << row
    end

    class Row
      include Virtus.model

      # 0: データ, 1: 小計, 2: 合計
      attribute :mode, Integer, default: 0
      attribute :financial_year, Integer
      attribute :kind_name, String
      attribute :construction_probability_name, String
      attribute :amounts, Array[Integer]

      def total_amount
        amounts.inject(:+)
      end

      def total_amount_text
        amount = total_amount
        amount.to_i.zero? ? '' : amount.to_s(:delimited)
      end

      def amount(index)
        amount = amounts[index]
        amount.to_i.zero? ? '' : amount.to_s(:delimited)
      end
    end
  end
end
