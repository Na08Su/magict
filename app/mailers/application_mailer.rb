class ApplicationMailer < ActionMailer::Base
  default from: "noreply@example.com",
          bcc: "sample+sent@example.com",
          reply_to: "sample+reply@example.com"
  # layout 'mailer'
end
