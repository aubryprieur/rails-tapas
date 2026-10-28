# Aperçu : http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome
    UserMailer.welcome(User.first)
  end

  def newsletter_mailer
    UserMailer.newsletter_mailer
  end
end
