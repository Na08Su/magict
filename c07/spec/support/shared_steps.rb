module SharedSteps
  step 'ログインしている' do
    # spec/rails_helper.rb config.before(:suite . で作成したユーザー
    Warden.test_mode!
    @current_user = User.last
    login_as(@current_user, scope: :user)
  end

  step ':elementボタンをクリックする' do |element|
    click_on element
  end

  step ':elementリンクをクリックする' do |element|
    click_on element
  end

  step '少し待つ' do
    wait_for_ajax
    sleep 0.3
  end
end
