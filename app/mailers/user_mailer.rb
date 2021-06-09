class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user  # Instance variable => available in view
    mail(to: @user.email, subject: 'Bienvenue sur Tapas!')
    # This will render a view in `app/views/user_mailer`!
  end

  def newsletter_mailer
    @posts_activities = Post.last(3)
    mail(to: User.pluck(:email), subject: "Hi, this is a test mail.")
  end

end
