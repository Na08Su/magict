module ApplicationHelper
  def login_path
    ENV['USE_DOORKEEPER_AUTHENTICATION'] ? user_doorkeeper_omniauth_authorize_path : new_user_session_path
  end

  def message_class(key)
    case key
    when 'notice' then 'success'
    when 'alert'  then 'danger'
    else 'info'
    end
  end
end
