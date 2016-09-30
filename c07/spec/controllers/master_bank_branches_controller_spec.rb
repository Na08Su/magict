require 'rails_helper'

describe MasterBankBranchesController do
  login_user

  describe 'GET #index' do
    include_examples 'http_status 200 ok'

    context '21件の支店データがある場合' do
      before do
        @master_bank = create(:master_bank) # 1対多の関連付け
        create_list(:master_bank_branch, 21, master_bank: @master_bank)
      end

      it '1ページ目は20件になること' do
        get :index, params: { master_bank_id: @master_bank }
        expect(assigns(:master_bank_branches).size).to eq Settings.per_page
      end

      it '2ページ目は1件になること' do
        get :index, params: { master_bank_id: @master_bank, page: 2 }
        expect(assigns(:master_bank_branches).size).to eq 1
      end
    end

    context '支店検索' do
      subject do
        get :index, params: { master_bank_id: @master_bank, q: condition }
        assigns(:master_bank_branches)
      end

      before do
        @master_bank  = create(:master_bank)
        @branch_data1 = create(:master_bank_branch, code: 1, name: '日本銀行', name_kana: 'ニホンギンコウ', master_bank: @master_bank)
        @branch_data2 = create(:master_bank_branch, code: 2, name: '関西銀行', name_kana: 'カンサイギンコウ', master_bank: @master_bank)
      end

      context '支店名称に日本を指定した場合' do
        let(:condition) { { name_cont: '日本' } }
        it { is_expected.to match_array([@branch_data1]) }
      end

      context '支店コードに2を指定した場合' do
        let(:condition) { { code_eq: 2 } }
        it { is_expected.to match_array([@branch_data2]) }
      end

      context '支店名称に銀行を指定した場合' do
        let(:condition) { { name_cont: '銀行' } }
        it { is_expected.to match_array([@branch_data1, @branch_data2]) }
      end

      context '支店コードに100を指定した場合' do
        let(:condition) { { code_eq: 100 } }
        it { is_expected.to be_blank }
      end
    end
  end

  describe 'GET #new' do
    subject { get :new, params: { master_bank_id: @master_bank } }

    before do
      @master_bank = create(:master_bank)
    end

    include_examples 'http_status 200 ok'

    it 'MasterBankBranchインスタンスが生成されること' do
      subject
      expect(assigns(:master_bank_branch)).to be_a_new(MasterBankBranch)
    end
  end

  describe 'POST #create' do
    subject { post :create, params: { master_bank_id: @master_bank, master_bank_branch: master_bank_branch } }

    before do
      @master_bank = create(:master_bank)
    end

    context '有効なパラメーターの場合' do
      let(:master_bank_branch) { { master_bank_code: @master_bank.code, code: 1, name: '横浜銀行', name_kana: 'ヨコハマギンコウ' } }

      it 'DBに新しいデータが追加されること' do
        expect { subject }.to change(MasterBankBranch, :count).by(1)
      end

      it 'indexページに遷移すること' do
        subject
        expect(response).to redirect_to master_bank_master_bank_branches_path
      end
    end

    context '無効なパラメータの場合' do
      let(:master_bank_branch) { { master_bank_id: @master_bank, code: 8, name: name, name_kana: 'カナ' } }
      let(:name) { nil }

      it 'DBに新しいデータが追加されないこと' do
        expect { subject }.not_to change(MasterBankBranch, :count)
      end

      it 'newページが再表示される' do
        subject
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    subject { get :edit, params: { master_bank_id: @master_bank, id: data.id } }

    before do
      @master_bank = create(:master_bank)
    end

    let(:data) { create(:master_bank_branch) }
    include_examples 'http_status 200 ok'

    it '@master_bank_branchに要求されたデータを割り当てること' do
      subject
      expect(assigns(:master_bank_branch)).to eq data
    end
  end

  describe 'PUT #update' do
    subject { patch :update, params: { master_bank_id: @master_bank.code, id: data.id, master_bank_branch: { code: code, name: name, name_kana: name_kana } } }

    before do
      @master_bank = create(:master_bank)
    end

    context '存在するデータの場合' do
      let(:data) { create(:master_bank_branch) }

      context '有効なパラメーターの場合' do
        let(:code)      { '100' }
        let(:name)      { '支店更新' }
        let(:name_kana) { 'シテンコウシン' }

        include_examples 'http_status 302 Found'

        it 'DB上で支店コードの値が更新されること' do
          expect { subject }.to change { data.reload.code }.from(data.code).to(code)
        end

        it 'DB上で支店名称の値が更新されること' do
          expect { subject }.to change { data.reload.name }.from(data.name).to(name)
        end
      end

      context '無効なパラメーターの場合' do
        let(:code)      { '' }
        let(:name)      { '' }
        let(:name_kana) { '' }

        include_examples 'http_status 200 ok'

        it 'DB上のフリガナは更新されないこと' do
          expect { subject }.to_not change { data.reload.name_kana }
        end

        it 'editページが再表示されること' do
          subject
          expect(response).to render_template :edit
        end
      end
    end

    context '要求されたデータが存在しない場合 ' do
      it 'リクエストはRecordNotFoundとなること' do
        expect do
          patch :update, params: { master_bank_id: @master_bank.code, id: '', master_bank_branch: attributes_for(:master_bank_branch) }
        end.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { master_bank_id: @master_bank.code, id: master_bank_branch.id } }

    before do
      @master_bank = create(:master_bank)
      create(:master_bank_branch, master_bank: @master_bank)
    end

    let(:master_bank_branch) { MasterBankBranch.first }

    context '存在するデータの場合' do
      include_examples 'http_status 302 Found'

      it 'DBから要求されたデータが削除される' do
        expect { subject }.to change(MasterBankBranch, :count).by(-1)
      end

      it '意図したデータが消えていること' do
        subject
        MasterBankBranch.find_by(id: master_bank_branch.id).should be_nil
      end

      it 'indexページに遷移すること' do
        subject
        expect(response).to redirect_to master_bank_master_bank_branches_path(master_bank_id: @master_bank.code)
      end
    end

    context '要求されたデータが存在しない場合' do
      it 'リクエストはRecordNotFoundとなること' do
        expect { delete :destroy, params: { master_bank_id: @master_bank.code, id: '' } }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
