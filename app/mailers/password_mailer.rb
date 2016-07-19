class PasswordMailer < ApplicationMailer

  def send_password

    mail to: user.email,
         subject: 'パスワードの再設定メールです'
  end
end
