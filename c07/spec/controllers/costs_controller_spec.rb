require 'rails_helper'

describe CostsController, type: :controller do
  login_user

  before(:all) { Cost.delete_all } # NOTE: 微妙・・・直したい
  let(:current_user) { User.last }
  let(:current_company) { current_user.company }

  describe 'GET #index' do
    include_examples 'http_status 200 ok'

    context '21件データがある場合' do
      before do
        create_list(:cost, 21, company: current_company)
      end

      it '1ページ目は20件になること' do
        get :index, params: {}
        expect(assigns(:costs).size).to eq Settings.per_page
      end

      it '2ページ目はデータが1件になること' do
        get :index, params: { page: 2 }
        expect(assigns(:costs).size).to eq 1
      end
    end

    describe '検索されるcostsのデータ' do
      subject do
        get :index, params: { q: condition }
        assigns(:costs)
      end

      before do
        @data1 = create(:cost, company: current_company, code: 111, name: 'あああ', cost_class: 1, budget_class: 1)
        @data2 = create(:cost, company: current_company, code: 123, name: 'いいい', cost_class: 2, budget_class: 2)
      end

      context 'name_contにあああを指定した場合' do
        let(:condition) { { name_cont: 'あああ' } }
        it { is_expected.to match_array([@data1]) }
      end

      context 'code_contが123の場合' do
        let(:condition) { { code_cont: '123' } }
        it { is_expected.to match_array([@data2]) }
      end

      context 'name_contにいいいを指定した場合' do
        let(:condition) { { name_cont: 'いいい' } }
        it { is_expected.to match_array([@data2]) }
      end

      context 'budget_class_eqにAを指定した場合' do
        let(:condition) { { budget_class_eq: 1 } }
        it { is_expected.to match_array([@data1]) }
      end

      context 'cost_class_eqに1を指定した場合' do
        let(:condition) { { cost_class_eq: 1 } }
        it { is_expected.to be_include(@data1) }
      end

      context 'budget_class_eqにABを指定した場合' do
        let(:condition) { { budget_class_eq: 3 } }
        it { is_expected.to be_blank }
      end
    end
  end

  describe 'GET #new' do
    subject { get :new, params: {} }

    include_examples 'http_status 200 ok'

    it 'Costインスタンスが生成されること' do
      subject
      expect(assigns(:cost)).to be_a_new(Cost)
    end
  end

  describe 'POST #create' do
    subject { post :create, params: { cost: cost } }

    context '有効なパラメーターの場合' do
      let(:cost) { { code: 10, name: 'test', cost_class: 'cash', budget_class: 'class_b' } }

      it 'DBに新しいデータが追加されること' do
        expect { subject }.to change(Cost, :count).by(1)
      end

      it 'indexページに遷移すること' do
        subject
        expect(response).to redirect_to costs_path
      end
    end

    context '無効なパラメーターの場合' do
      let(:cost) { { code: 100, name: name, cost_class: 'current_deposit', budget_class: 'class_c' } }
      let(:name) { nil }

      it 'DBに新しいデータが追加されないこと' do
        expect { subject }.not_to change(Cost, :count)
      end

      it 'newページが再表示される' do
        subject
        expect(response).to render_template :new
      end

      include_examples 'http_status 200 ok'
    end
  end

  describe 'GET #edit' do
    subject { get 'edit', params: { id: data.id } }
    let(:data) { create(:cost, company: current_company) }

    include_examples 'http_status 200 ok'

    it '@costに要求されたデータを割り当てること' do
      subject
      expect(assigns(:cost)).to eq data
    end
  end

  describe 'PUT #update' do
    context '存在するデータの場合' do
      subject { patch :update, params: { id: data.id, cost: { name: name, code: code } } }

      let(:data) { create(:cost, company: current_company) }

      context '有効なパラメーターの場合' do
        let(:name) { '更新' }
        let(:code) { 100 }

        include_examples 'http_status 302 Found'

        it 'DBで指定された値が更新される' do
          original_name = data.name
          expect { subject }.to change { data.reload.name }.from(original_name).to(name)
        end

        it 'Codeが書き換えられるのか確認する' do
          original_code = data.code
          expect { subject }.to change { data.reload.code }.from(original_code).to(code)
        end
      end

      context '無効なパラメーターの場合' do
        let(:name) { ' ' }
        let(:code) { ' ' }

        include_examples 'http_status 200 ok'

        it 'DBのデータは更新されないこと' do
          expect { subject }.to_not change { data.reload.name }
        end
      end
    end

    context '要求されたデータが存在しない場合' do
      it 'リクエストはRecordNotFoundとなること' do
        expect { patch :update, params: { id: 1, cost: attributes_for(:cost) } }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:cost) { create(:cost, company: current_company) }
    subject { delete :destroy, params: { id: cost.id } }

    context '存在するデータの場合' do
      include_examples 'http_status 302 Found'

      it 'DBから要求されたデータが削除される' do
        cost
        expect { subject }.to change(Cost, :count).by(-1)
      end

      it '意図したデータが消えていること' do
        subject
        Cost.find_by(id: cost.id).should be_nil
      end

      it 'indexページに遷移すること' do
        subject
        expect(response).to redirect_to costs_path
      end
    end

    context '要求されたデータが存在しない場合' do
      it 'リクエストはRecordNotFoundとなること' do
        expect { delete :destroy, params: { id: '' } }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
