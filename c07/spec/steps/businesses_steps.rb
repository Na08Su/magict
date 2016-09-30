# encoding: utf-8
require 'rails_helper'

steps_for :business_integration do
  step '業務作成画面に遷移している' do
    visit new_business_path
    expect(page).to have_content('業務登録')
  end

  step '業務編集画面に遷移している' do
    visit edit_business_path(@business)
    expect(page).to have_content('業務編集')
  end

  step '業務が作成されている' do
    @business = create(:business, company: @current_user.company, name: 'テスト業務名0001', financial_start_year: 32, profit_division_id: 1)
  end
end

steps_for :business_create do
  step 'フォームに登録内容を入力する' do
    fill_in :business_financial_start_year, with: '32'
    fill_in :business_name, with: '業務名1234'
    select '本社経費', from: :business_profit_division_id
  end

  step '業務が登録されていること' do
    expect(page).to have_current_path(businesses_path)
    expect(page).to have_content('業務名1234')
  end
end

steps_for :business_update do
  step 'フォームに変更内容を入力する' do
    fill_in :business_name, with: '変更業務名'
    select '本社経費', from: :business_profit_division_id
  end

  step '業務が更新されていること' do
    expect(page).to have_current_path(businesses_path)
    expect(page).to have_content('変更業務名')
  end
end

steps_for :business_delete do
  step '業務が削除されていること' do
    expect(page).to have_current_path(businesses_path)
    expect(page).to_not have_content(@business.code)
  end
end
