class Business
  module CodeNumberGenerator
    extend ActiveSupport::Concern

    included do
      before_validation :code_number_fill_zero
      before_validation :generate_code

      # code_numberを自動生成する際の区切り数
      DELIMITER_NUM = 100
    end

    # code_number仕様
    # company_id, financial_start_yearが必須
    #
    # 使用されている管理番号の最大の値を取り、
    # その値を100で割り切れる数に変換したものに+100をし、
    # 5桁まで0埋めしたもの
    #
    # ex. maximumが101の場合は、00200が返る
    def build_code_number
      fail ArgumentError, 'build code_number method is need to define company_id, financial_start_year.' if company_id.blank? || financial_start_year.blank?

      maximum_business_code_number = Business.where(company_id: company_id, financial_start_year: financial_start_year).maximum(:code_number)
      maximum_contract_construction_code = ContractConstruction.where(company_id: company_id, financial_year: financial_start_year).maximum(:code)
      maximum_code_number = [maximum_business_code_number.to_i, maximum_contract_construction_code.to_i].max
      self.code_number = next_code_number(maximum_code_number)
      code_number
    end

    def next_construction_code
      current_maximum_code = contract_constructions.maximum(:code)
      current_maximum_code = code_number if current_maximum_code.blank?
      next_code = current_maximum_code.to_i + 1
      format('%05d', next_code.to_i)
    end

    private

    def next_code_number(current_maximum_code_number)
      code_number = format('%05d', ((current_maximum_code_number.to_i / DELIMITER_NUM) * DELIMITER_NUM) + DELIMITER_NUM)
      if ContractConstruction.exists?(company_id: company_id, financial_year: financial_start_year, code: code_number)
        next_code_number(code_number)
      else
        code_number
      end
    end

    # code_numberを強制で5桁まで0埋め
    def code_number_fill_zero
      self.code_number = format('%05d', code_number.to_i)
    end

    # code値を生成(viewからcode値を渡すことはできない)
    def generate_code
      self.code = [financial_start_year, profit_division_id, code_number].join('-')
    end
  end
end
