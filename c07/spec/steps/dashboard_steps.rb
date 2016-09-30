# encoding: utf-8
require 'rails_helper'

step 'ダッシュボードに遷移する' do
  visit root_path
end

step '最近の出来事が表示されていること' do
  # page.save_screenshot("#{ Rails.root }/test.png")
  expect(page).to have_content('最近の出来事')
end
