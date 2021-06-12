class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user  # Instance variable => available in view
    mail(to: @user.email, subject: 'Bienvenue sur Tapas!')
    # This will render a view in `app/views/user_mailer`!
  end

  def newsletter_mailer
    # (marche pas : j'ai tous les posts, pas de sélection)
    @posts_activities = Post.includes(:readings, :likes, :calls, :teams).where("created_at >= ?", Date.today.at_beginning_of_week)
    # (marche pas)
    @posts_activities2 = Post.joins(:teams).where("teams.created_at >= ?", Date.today.at_beginning_of_week)
    # (marche pas : bug, mal écrit)
    @posts_activities3 = Post.joins(:teams, :readings).where("teams.created_at >= ?" or "readings.created_at >= ?", Date.today.at_beginning_of_week)
    # (marche pas)
    mail(to: User.pluck(:email), subject: "Hi, this is a test mail.")
  end

  private

# A travailler
  def reading_ao_week
    # Reading.where(:created_at => (Date.today - 7)..(Date.today))
    # readings = Reading.where("created_at >= ?", Date.today.at_beginning_of_week)
    Post.includes(:readings).where("created_at >= ?", Date.today.at_beginning_of_week)
  end
# A travailler

end
