require 'rails_helper'

RSpec.describe AccountHeadingsController, type: :controller do
  login_user

  before(:all) { AccountHeading.delete_all } # NOTE: 微妙・・・直したい
  let(:current_user) { User.last }
  let(:current_company) { current_user.company }

  describe 'GET #index' do
    include_examples 'http_status 200 ok'

    context '21件データがある場合' do
      before do
        create_list(:account_heading, 21, company: current_company)
      end

      it '1ページ目は20件になること' do
        get :index, params: {}
        expect(assigns(:account_headings).size).to eq Settings.per_page
      end

      it '2ページ目は1件になること' do
        get :index, params: { page: 2 }
        expect(assigns(:account_headings).size).to eq 1
      end
    end

    describe '検索されるaccount_headingのデータ' do
      subject do
        get :index, params: { q: condition }
        assigns(:account_headings)
      end

      before do
        @account_heading1 = create(:account_heading, company: current_company, code: 55, name: 'sample', division: 3)
        @account_heading2 = create(:account_heading, company: current_company, code: 77, name: 'matt',   division: 5)
      end

      context 'name_contにmattを指定した場合' do
        let(:condition) { { name_cont: 'matt' } }
        it { is_expected.to match_array([@account_heading2]) }
      end

      context 'code_eqに55を指定した場合' do
        let(:condition) { { code_eq: 55 } }
        it { is_expected.to be_include(@account_heading1) }
      end

      context 'division_eqに5を指定した場合' do
        let(:condition) { { division_eq: 5 } }
        it { is_expected.to match_array([@account_heading2]) }
      end

      context 'name_contにNotFoundと指定した場合' do
        let(:condition) { { name_cont: 'NotFound' } }
        it { is_expected.to be_blank }
      end
    end
  end

  describe 'GET #new' do
    subject { get :new, params: {} }

    include_examples 'http_status 200 ok'

    it 'AccountHeadingインスタンスが生成されること' do
      subject
      expect(assigns(:account_heading)).to be_a_new(AccountHeading)
    end
  end

  describe 'POST #create' do
    subject { post :create, params: { account_heading: account_heading } }

    context '有効なパラメーターの場合' do
      let(:account_heading) { { code: 20, name: 'sample', division: 'profit' } }
      it 'DBに新しいデータが追加されること ' do
        expect { subject }.to change(AccountHeading, :count).by(1)
      end

      it 'indexページに遷移すること' do
        subject
        expect(response).to redirect_to account_headings_path
      end
    end

    context '無効なパラメーターの場合' do
      let(:account_heading) { { code: 66, name: name, division: 'capital' } }
      let(:name) { nil }

      it 'DBに新しいデータが追加されないこと' do
        expect { subject }.not_to change(AccountHeading, :count)
      end

      it 'newページが再描画される' do
        subject
        expect(response).to render_template :new
      end

      include_examples 'http_status 200 ok'
    end
  end

  describe 'GET #edit' do
    subject { get :edit, params: { id: account_heading.id } }
    let(:account_heading) { create(:account_heading, company: current_company) }

    include_examples 'http_status 200 ok'

    it '@account_headingに要求されたデータを割り当てること' do
      subject
      expect(assigns(:account_heading)).to eq account_heading
    end
  end

  describe 'PUT #update' do
    context '存在するデータの場合 ' do
      subject { patch :update, params: { id: data, account_heading: { code: code, name: name } } }
      let(:data) { create(:account_heading, company: current_company) }

      context '有効なパラメーターの場合' do
        let(:code) { '150' }
        let(:name) { '更新' }

        include_examples 'http_status 302 Found'

        it 'DBでnameの値が更新されること' do
          expect { subject }.to change { data.reload.name }.from(data.name).to(name)
        end

        it 'DBでcodeの値が更新されること' do
          expect { subject }.to change { data.reload.code }.from(data.code).to(code)
        end
      end

      context '無効なパラメーターの場合' do
        let(:code) { ' ' }
        let(:name) { ' ' }

        include_examples 'http_status 200 ok'

        it 'DBのデータは更新されないこと' do
          expect { subject }.to_not change { data.reload.name }
        end

        it 'editページが再描画されること' do
          subject
          expect(response).to render_template :edit
        end
      end
    end

    context '要求されたデータが存在しない場合' do
      it 'リクエストはRecordNotFoundとなること' do
        expect { patch :update, params: { id: '', account_heading: attributes_for(:account_heading) } }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:account_heading) { create(:account_heading, company: current_company) }
    subject { delete :destroy, params: { id: account_heading.id } }

    context '存在するデータの場合' do
      include_examples 'http_status 302 Found'

      it 'DBから要求されたデータが削除される' do
        account_heading
        expect { subject }.to change(AccountHeading, :count).by(-1)
      end

      it '意図したデータが消えていること' do
        subject
        AccountHeading.find_by(id: account_heading.id).should be_nil
      end

      it 'indexページに遷移すること' do
        subject
        expect(response).to redirect_to account_headings_path
      end
    end

    context '要求されたデータが存在しない場合' do
      it 'リクエストはRecordNotFoundとなること' do
        expect { delete :destroy, params: { id: '' } }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
