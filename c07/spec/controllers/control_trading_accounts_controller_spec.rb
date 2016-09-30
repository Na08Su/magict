require 'rails_helper'

describe ControlTradingAccountsController do
  login_user

  let(:current_user) { User.last }
  let(:current_company) { current_user.company }

  describe 'GET #index' do
    include_examples 'http_status 200 ok'

    context '21件データがある場合' do
      before do
        master_bank = create(:master_bank)
        master_branch = create(:master_bank_branch, master_bank: master_bank)
        create_list(:control_trading_account, 21, company: current_company, bank_code: master_bank.code, bank_branch_code: master_branch.code)
      end

      it '1ページ目は20件になること' do
        get :index, params: {}
        expect(assigns(:control_trading_accounts).size).to eq Settings.per_page
      end

      it '2ページ目は1件になること' do
        get :index, params: { page: '2' }
        expect(assigns(:control_trading_accounts).size).to eq 1
      end
    end

    describe '検索されるcontrol_trading_accountのデータ' do
      subject do
        get :index, params: { q: condition }
        assigns(:control_trading_accounts)
      end

      before do
        create(:master_bank, code: '0001')
        create(:master_bank, code: '0005')
        create(:master_bank_branch, master_bank_code: '0001', code: '001')
        create(:master_bank_branch, master_bank_code: '0005', code: '002')
        @data1 = create(:control_trading_account, company: current_company, bank_code: '0001', bank_branch_code: '001', account_number: '11112222',
                                                  account_name: '山田太郎', account_name_kana: 'ヤマダタロウ', bank_short_name: 'みずほ東京', account_headings: 1111, limit_borrowing: '10000')

        @data2 = create(:control_trading_account, company: current_company, bank_code: '0005', bank_branch_code: '002', account_number: '33334444',
                                                  account_name: '佐藤花子', account_name_kana: 'サトウハナコ', bank_short_name: 'UFJ丸の内', account_headings: 1111, limit_borrowing: '50000')
      end

      context 'bank_code_contに1を指定した場合' do
        let(:condition) { { bank_code_cont: 1 } }
        it { is_expected.to match_array([@data1]) }
      end

      context 'bank_code_contに0を指定した場合' do
        let(:condition) { { bank_code_cont: 0 } }
        it { is_expected.to match_array([@data1, @data2]) }
      end

      context 'bank_branch_code_contに2を指定した場合' do
        let(:condition) { { bank_branch_code_cont: 2 } }
        it { is_expected.to match_array([@data2]) }
      end

      context 'bank_code_contに9を指定した場合' do
        let(:condition) { { bank_code_cont: 9 } }
        it { is_expected.to be_blank }
      end
    end
  end

  describe 'GET #new' do
    subject { get :new, params: {} }
    include_examples 'http_status 200 ok'

    it 'ControlTradingAccountインスタンスが生成されること' do
      subject
      expect(assigns(:control_trading_account)).to be_a_new(ControlTradingAccount)
    end
  end

  describe 'POST #create' do
    before do
      master_bank = create(:master_bank, code: '0001')
      create(:master_bank_branch, master_bank: master_bank, code: '001')
    end

    subject { post :create, params: { control_trading_account: control_trading_account } }

    context '有効なパラメーターの場合' do
      let(:control_trading_account) do
        { company_id: 1, bank_code: '0001', bank_branch_code: '001', account_number: '11112222', account_name: '山田太郎',
          account_name_kana: 'ヤマダタロウ', bank_short_name: 'みずほ東京', account_headings: '1234', limit_borrowing: '10000' }
      end

      it 'DBに新しいデータが追加されること' do
        expect { subject }.to change(ControlTradingAccount, :count).by(1)
      end

      it 'indexページに遷移すること' do
        subject
        expect(response).to redirect_to control_trading_accounts_path
      end
    end

    context '無効なパラメーターの場合' do
      let(:control_trading_account) do
        { company_id: 1, bank_code: '0001', bank_branch_code: '001', account_number: account_number, account_name: '山田太郎',
          account_name_kana: 'ヤマダタロウ', bank_short_name: 'みずほ東京', account_headings: '6789', limit_borrowing: '10000' }
      end
      let(:account_number) { nil }
      it 'DBに新しいデータが追加されないこと' do
        expect { subject }.not_to change(ControlTradingAccount, :count)
      end

      it 'newページが再掲される' do
        subject
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    subject { get :edit, params: { id: data.id } }

    before do
      @master_bank = create(:master_bank)
      @master_branch = create(:master_bank_branch, master_bank: @master_bank)
    end

    let(:data) { create(:control_trading_account, company: current_company, bank_code: @master_bank.code, bank_branch_code: @master_branch.code) }
    include_examples 'http_status 200 ok'

    it 'control_trading_accountに要求されたデータを割り当てること' do
      subject
      expect(assigns(:control_trading_account)).to eq data
    end
  end

  describe 'PUT #update' do
    context '存在するデータの場合' do
      subject { patch :update, params: { id: data, control_trading_account: { account_number: account_number, account_name: account_name, account_name_kana: account_name_kana } } }

      before do
        @master_bank = create(:master_bank)
        @master_branch = create(:master_bank_branch, master_bank: @master_bank)
      end

      let(:data) { create(:control_trading_account, company: current_company, bank_code: @master_bank.code, bank_branch_code: @master_branch.code) }

      context '有効なパラメーターの場合' do
        let(:account_number)    { '12345678' }
        let(:account_name)      { '更新さん' }
        let(:account_name_kana) { 'コウシン' }

        include_examples 'http_status 302 Found'

        it 'DB上でaccount_numberの値が更新されること' do
          expect { subject }.to change { data.reload.account_number }.from(data.account_number).to(account_number)
        end

        it 'DB上でaccount_nameの値が更新されること' do
          expect { subject }.to change { data.reload.account_name }.from(data.account_name).to(account_name)
        end
      end

      context '無効なパラメーターの場合' do
        let(:account_number)    { '' }
        let(:account_name)      { '' }
        let(:account_name_kana) { '' }
        include_examples 'http_status 200 ok'

        it 'DB上のaccount_numberは更新されないこと' do
          expect { subject }.to_not change { data.reload.account_number }
        end

        it 'editページが再表示される' do
          subject
          expect(response).to render_template :edit
        end
      end
    end

    context '要求されたデータが存在しない場合' do
      it 'リクエストはRecordNotFoundとなること' do
        expect { patch :update, params: { id: '', control_trading_account: attributes_for(:control_trading_account) } }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      master_bank_branch = create(:master_bank_branch)
      create(:control_trading_account, company: current_company, bank_branch_code: master_bank_branch.code, bank_code: master_bank_branch.master_bank_code)
    end
    let(:control_trading_account) { ControlTradingAccount.first }
    subject { delete :destroy, params: { id: control_trading_account.id } }

    context '存在するデータの場合' do
      include_examples 'http_status 302 Found'

      it 'DBから要求されたデータが削除される' do
        expect { subject }.to change(ControlTradingAccount, :count).by(-1)
      end

      it '意図したデータが消えていること' do
        subject
        ControlTradingAccount.find_by(id: control_trading_account.id).should be_nil
      end

      it 'indexページに遷移すること' do
        subject
        expect(response).to redirect_to control_trading_accounts_path
      end
    end

    context '要求されたデータが存在しない場合' do
      it 'リクエストはRecordNotFoundとなること' do
        expect { delete :destroy, params: { id: '' } }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
