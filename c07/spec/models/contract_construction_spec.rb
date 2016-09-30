require 'rails_helper'

RSpec.describe ContractConstruction, type: :model do
  describe '#generate_decision_no' do
    subject { construction.send(:generate_decision_no) }

    let(:construction) { build(:contract_construction, financial_year: 20) }

    context '企業に登録されている担当工事が無い場合' do
      specify { is_expected.to eq '20-001' }
    end

    context '企業に登録されている担当工事の数が5の場合' do
      before do
        create_list(:contract_construction, 5, company: construction.company)
      end

      specify { is_expected.to eq '20-006' }
    end
  end
end
