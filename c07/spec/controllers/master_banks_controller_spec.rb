require 'rails_helper'

describe MasterBanksController do
  login_user

  describe 'GET #index' do
    include_examples 'http_status 200 ok'

    context '21件データがある場合' do
      before do
        create_list(:master_bank, 21)
      end

      it '1ページ目は20件になること' do
        get :index, params: {}
        expect(assigns(:master_banks).size).to eq Settings.per_page
      end

      it '2ページ目は1件になること' do
        get :index, params: { page: '2' }
        expect(assigns(:master_banks).size).to eq 1
      end
    end

    describe '検索されるmaster_banksのデータ' do
      subject do
        get :index, params: { q: condition }
        assigns(:master_banks)
      end

      before do
        @data1 = create(:master_bank, code: 11, name: '町田銀行', name_kana: 'マチダ')
        @data2 = create(:master_bank, code: 22, name: '鎌倉銀行', name_kana: 'カマクラ')
      end

      context 'code_eqに11を指定した場合' do
        let(:condition) { { code_eq: 11 } }
        it { is_expected.to match_array([@data1]) }
      end

      context 'name_contに町田を指定した場合' do
        let(:condition) { { name_cont: '町田' } }
        it { is_expected.to match_array([@data1]) }
      end

      context 'code_eqに2を指定した場合' do
        let(:condition) { { code_eq: 2 } }
        it { is_expected.to be_blank }
      end

      context 'name_contに銀行と指定した場合' do
        let(:condition) { { name_cont: '銀行' } }
        it { is_expected.to match_array([@data1, @data2]) } # 2件マッチする
      end
    end
  end

  describe 'GET #new' do
    subject { get :new, params: {} }
    include_examples 'http_status 200 ok'

    it 'MasterBankインスタンスが生成されること' do
      subject
      expect(assigns(:master_bank)).to be_a_new(MasterBank)
    end
  end

  describe 'POST #create' do
    subject { post :create, params: { master_bank: master_bank } }

    context '有効なパラメーターの場合' do
      let(:master_bank) { { code: 1, name: '渋谷銀行', name_kana: 'シブヤ' } }

      it 'DBに新しいデータが追加されること' do
        expect { subject }.to change(MasterBank, :count).by(1)
      end

      it 'indexページに遷移すること' do
        subject
        expect(response).to redirect_to master_banks_path
      end
    end

    context '無効なパラメーターの場合' do
      let(:master_bank) { { code: 66, name: name, name_kana: 'フリガナ' } }
      let(:name) { nil }

      it 'DBに新しいデータが追加されないこと' do
        expect { subject }.not_to change(MasterBank, :count)
      end

      it 'newページが再表示される' do
        subject
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    subject { get :edit, params: { id: data.id } }
    let(:data) { create(:master_bank) }
    include_examples 'http_status 200 ok'

    it '@master_bankに要求されたデータを割り当てること' do
      subject
      expect(assigns(:master_bank)).to eq data
    end
  end

  describe 'PUT #update' do
    context '存在するデータの場合' do
      subject { patch :update, params: { id: data.code, master_bank: { name: name, name_kana: kana } } }
      let(:data) { create(:master_bank) }

      context '有効なパラメーターの場合' do
        let(:name) { '更新' }
        let(:kana) { 'コウシン' }

        include_examples 'http_status 302 Found'

        it 'DB上でnameの値が更新されること' do
          expect { subject }.to change { data.reload.name }.from(data.name).to(name)
        end
      end

      context '無効なパラメーターの場合' do
        let(:code) { '' }
        let(:name) { '' }
        let(:kana) { '' }
        include_examples 'http_status 200 ok'

        it 'DB上のname_kanaは更新されないこと' do
          expect { subject }.to_not change { data.reload.name_kana }
        end

        it 'editページが再表示されること' do
          subject
          expect(response).to render_template :edit
        end
      end
    end

    context '要求されたデータが存在しない場合' do
      it 'リクエストはRecordNotFoundとなること' do
        expect { patch :update, params: { id: '', master_bank: attributes_for(:master_bank) } }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      create(:master_bank)
    end
    let(:master_bank) { MasterBank.first }
    subject { delete :destroy, params: { id: master_bank.id } }

    context '存在するデータの場合' do
      include_examples 'http_status 302 Found'

      it 'DBから要求されたデータが削除される' do
        expect { subject }.to change(MasterBank, :count).by(-1)
      end

      it '意図したデータが消えていること' do
        subject
        MasterBank.find_by(code: master_bank.code).should be_nil
      end

      it 'indexページに遷移すること' do
        subject
        expect(response).to redirect_to master_banks_path
      end
    end

    context '要求されたデータが存在しない場合' do
      it 'リクエストはRecordNotFoundとなること' do
        expect { delete :destroy, params: { id: '' } }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
