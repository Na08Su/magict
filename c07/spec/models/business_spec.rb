require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#already_used_code_number' do
    subject { business.send(:already_used_code_number) }

    let(:business) { build(:business, code_number: '00100') }

    context '重複したコードが、Business, ContractConstructionにも無い時' do
      it 'business not have errors' do
        expect { subject }.not_to change { business.errors.size }
      end
    end

    context 'Businessに重複したコードがある場合' do
      before do
        create(:business, company: business.company, code_number: '00100')
      end

      it 'business should have error' do
        expect { subject }.to change { business.errors.size }.from(0).to(1)
      end

      it 'business error should be already used' do
        subject
        business.errors.first.should eq [:code_number, I18n.t('errors.messages.already_used', model: Business.model_name.human)]
      end
    end

    context 'ContractConstructionに重複したコードがある場合' do
      before do
        create(:contract_construction, company: business.company, code: '00100')
      end

      it 'business should have error' do
        expect { subject }.to change { business.errors.size }.from(0).to(1)
      end

      it 'business error should be already used' do
        subject
        business.errors.first.should eq [:code_number, I18n.t('errors.messages.already_used', model: ContractConstruction.model_name.human)]
      end
    end

    context 'Businessに重複するコードがあるが、別企業の場合' do
      before do
        create(:business, code_number: '00100')
      end

      it 'business not have errors' do
        expect { subject }.not_to change { business.errors.size }
      end
    end
  end

  describe '#build_code_number' do
    subject { business.build_code_number }

    let(:business) { create(:business) }

    context 'company_idがnilの場合' do
      before { business.company_id = nil }
      it { expect { subject }.to raise_error ArgumentError, 'build code_number method is need to define company_id, financial_start_year.' }
    end

    context 'financial_start_yearがnilの場合' do
      before { business.financial_start_year = nil }
      it { expect { subject }.to raise_error ArgumentError, 'build code_number method is need to define company_id, financial_start_year.' }
    end

    context 'BusinessにもContractConstructionにも登録がない場合' do
      it { is_expected.to eq '00100' }
    end

    context 'Businessが登録されている場合' do
      before { create(:business, company: business.company, code_number: '00111') }
      it { is_expected.to eq '00200' }
    end

    context 'ContractConstructionが登録されている場合' do
      before { create(:contract_construction, company: business.company, code: '02000') }
      it { is_expected.to eq '02100' }
    end

    context 'Business, ContractConstructionが両方登録されている場合' do
      before do
        create(:business, company: business.company, code_number: '03100')
        create(:contract_construction, company: business.company, code: '04444')
      end

      it '両方の最大値を取り、その値に区切り数を足したコードが返ってくること' do
        is_expected.to eq '04500'
      end
    end
  end

  describe '#next_construction_code' do
    subject { business.next_construction_code }

    let(:business) { build(:business, code_number: code_number, company: create(:company)) }

    context 'when code_nubmer is nil' do
      let(:code_number) { nil }
      it { is_expected.to eq '00001' }
    end

    context 'when code_number is "00100"' do
      let(:code_number) { '00100' }
      it { is_expected.to eq '00101' }
    end

    context 'when code_number is "00100" and used "00101"' do
      before do
        business.save!
        create(:contract_construction, company: business.company, business: business, code: '00101')
      end

      let(:code_number) { '00100' }
      it { is_expected.to eq '00102' }
    end
  end
end
