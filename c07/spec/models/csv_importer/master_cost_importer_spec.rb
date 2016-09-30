require 'rails_helper'

# FIXME: 一旦pending
RSpec.describe CsvImporter::MasterCostImporter, type: :model, skip: true do
  describe '#execute' do
    subject { CsvImporter::MasterCostImporter.new(file: file).execute }

    let(:file) { Rack::Test::UploadedFile.new(file_path, 'text/csv') }

    context '正しいCSVが指定された場合' do
      before { Cost.delete_all }
      let(:file_path) { Rails.root.join('spec/fixtures/csv/master_costs.csv') }

      it 'データが作成されること' do
        expect { subject }.to change { Cost.count }.from(0).to(17)
      end

      context 'データが存在している場合' do
        before do
          master_cost = Cost.find_by(code: 110) || build(:master_cost, code: 110)
          master_cost.update!(name: 'TEST', cost_class: Cost.cost_classes[:cash_over_short], budget_class: Cost.budget_classes[:construction_cost_machine])
        end

        it { expect { subject }.to raise_error CsvImporter::RowInvalid }
        # it 'データが更新されていること' do
        #   expect { subject }.to change { Cost.find_by(code: 110).name }.from('TEST').to('RAC')
        # end

        # it '他のデータは新規作成されていること' do
        #   expect { subject }.to change { Cost.count }.from(1).to(17)
        # end
      end

      context '名前の重複するデータが存在していた場合' do
        before do
          create(:master_cost, code: (Cost.maximum(:code).to_i + 1), name: 'RAC',
                               cost_class: Cost.cost_classes[:cash_over_short],
                               budget_class: Cost.budget_classes[:construction_cost_machine]) unless Cost.find_by(name: 'RAC')
        end

        it 'RowInvalidが発生すること' do
          expect { subject }.to raise_error CsvImporter::RowInvalid
        end
      end
    end

    context '空のCSVが指定された場合' do
      let(:file_path) { Rails.root.join('spec/fixtures/csv/master_costs_no_rows.csv') }

      it 'エラーにならないこと' do
        expect { subject }.to_not raise_error
      end
    end

    context 'headerのみのCSVが指定された場合' do
      let(:file_path) { Rails.root.join('spec/fixtures/csv/master_costs_only_header.csv') }

      it 'エラーにならないこと' do
        expect { subject }.to_not raise_error
      end
    end

    context 'cost_class, budget_classに定義されていない値が入っていた場合' do
      let(:file_path) { Rails.root.join('spec/fixtures/csv/master_costs_invalid_enum.csv') }

      it 'RowInvalidが発生すること' do
        expect { subject }.to raise_error CsvImporter::RowInvalid
      end
    end

    context 'CSV以外のファイルが指定された場合' do
      let(:file_path) { Rails.root.join('spec/fixtures/zip/master_costs.zip') }

      it 'FileInvalidが発生すること' do
        expect { subject }.to raise_error CsvImporter::FileInvalid
      end
    end

    context 'ファイルが指定されていない場合' do
      let(:file) { nil }

      it 'FileInvalidが発生すること' do
        expect { subject }.to raise_error CsvImporter::FileInvalid
      end
    end
  end
end
