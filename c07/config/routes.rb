Rails.application.routes.draw do
  if ENV['USE_DOORKEEPER_AUTHENTICATION']
    devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  else
    devise_for :users
  end

  root to: 'dashboard#index'

  # 業務
  resources :businesses do
    post :show_modal, on: :collection
    get :export_excel, on: :collection
  end

  # 工事(現場システムで登録されたもの)
  resources :constructions, only: [] do
    post :show_modal, on: :collection
  end

  # 営業中工事
  resources :construction_infos do
    post :show_modal, on: :collection
    get :expect_order_list, on: :collection
    get :export_excel_for_expect_order_list, on: :collection
  end

  # 担当工事
  resources :contract_constructions do
    post :show_modal, on: :collection
    get :export_excel, on: :collection
    get :reflection_by_financial_year_and_code, on: :collection

    # 実行予算
    resources :budgets do
      collection do
        match '(/:budget_id)/costs_reflect_from_quotation', to: 'budgets#costs_reflect_from_quotation', as: :costs_reflect_from_quotation, via: [:get, :post]
      end
    end
  end

  # 見積
  resources :quotations do
    post :show_modal, on: :collection
    post :create_details, to: 'quotation_details#create'

    resources :quotation_details, only: [:index]
  end

  # 原価
  resources :costs do
    put :restore, on: :member
    post :download, on: :collection
    post :import, on: :collection
  end

  resources :account_headings do
    post :download, on: :collection
  end

  resources :master_banks do
    resources :master_bank_branches
  end
  # 取引先口座管理
  resources :control_trading_accounts
  # 定例引落
  resources :regular_debit_accounts do
    delete :destroy_all, on: :collection
  end
  resources :companies, only: [] do
    post :show_modal, on: :collection
  end

  resources :company_relations do
    get :export_excel, on: :collection
  end

  # 出金伝票
  resources :disbursement_slips do
  end

  # 伝票
  resources :slips do
  end

  # 伝票分類
  resources :slip_types do
    put :restore, on: :member
  end

  # システム共通設定
  resource :company_setting, only: [:edit, :update]

  resources :report_of_businesses do
    get :construction_summary, on: :collection
    get :export_construction_summary, on: :collection
  end

  # 資金マスタ
  resources :slip_resources do
    put :restore, on: :member
  end

  # 部門マスタ
  resources :divisions do
    put :restore, on: :member
      # 部署マスタ設定
      resources :departments, only: [:index, :new, :create, :edit, :update, :destroy] do
        put :restore, on: :member
      end
  end

  namespace :csv do
    namespace :upload do
      resources :quotations, only: [:index] do
        post :index, on: :collection, to: 'quotations#execute'
      end
    end
  end
end
