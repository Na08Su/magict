module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def doorkeeper
      oauth_data = request.env['omniauth.auth']
      user = User.find_or_create_with_oauth(oauth_data)

      if user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'mock'
        sign_in_and_redirect user, event: :authentication
      else
        session['devise.doorkeeper_data'] = request.env['omniauth.auth']
        redirect_to root_url, alert: user.errors
      end
    end
  end
end
