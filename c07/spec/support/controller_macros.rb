module ControllerMacros
  def login_user
    before(:each) do
      controller.stub(:authenticate_user!).and_return true
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = User.last # already created rails_helper.rb before(:suite)
      sign_in user
    end
  end
end
