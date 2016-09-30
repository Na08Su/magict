# encoding: utf-8
require 'rails_helper'

steps_for :construction_infos_integration do
  step '営業中工事作成画面に遷移している' do
    visit new_construction_info_path
  end

  step 'フォームに登録内容を入力する' do
    fill_in :construction_info_site_name, with: '現場名'
    fill_in :construction_info_construction_name, with: '工事名'
    fill_in :construction_info_enactment_location, with: '施工場所'
    fill_in :construction_info_schedule_start, with: '2016/08/01'
    fill_in :construction_info_schedule_end, with: '2016/08/31'
    fill_in :construction_info_enactment_schedule_start, with: '2016/08/05'
    fill_in :construction_info_enactment_schedule_end, with: '2016/08/28'
    select 'AA : 100%着工', from: :construction_info_master_construction_probability_id
  end

  step '営業中工事が登録されていること' do
    expect(page).to have_current_path(construction_infos_path)
    expect(page).to have_content('営業中工事:「工事名」を登録しました')
  end

  step '営業中工事が作成されている' do
    @construction_info = create(:construction_info, company: @current_user.company)
  end

  step '営業中工事編集画面に遷移している' do
    visit edit_construction_info_path(@construction_info)
  end

  step 'フォームに変更内容を入力する' do
    fill_in :construction_info_construction_name, with: '変更後工事名'
    select '一括工事1000以上', from: :construction_info_master_construction_model_id
    fill_in :construction_info_building_contractor, with: '建築業者'
    fill_in :construction_info_expected_amount, with: 12345000
    select '1 : 出来高請求', from: :construction_info_master_bill_division_id
    fill_in :construction_info_recital, with: '備考欄に入力'
  end

  step '営業中工事が更新されていること' do
    expect(page).to have_current_path(construction_infos_path)
    expect(page).to have_content('営業中工事:「変更後工事名」を更新しました')
  end

  step '見積が作成されている' do
    create(:quotation, company: @current_user.company)
  end

  step '見積を選択する' do
    step '見積情報取得ボタンをクリックする'
  end
end

steps_for :business_delete do
  step '業務が削除されていること' do
    expect(page).to have_current_path(businesses_path)
    expect(page).to_not have_content(@business.code)
  end
end
