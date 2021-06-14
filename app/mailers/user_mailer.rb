class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user  # Instance variable => available in view
    mail(to: @user.email, subject: 'Bienvenue sur Tapas!')
    # This will render a view in `app/views/user_mailer`!
  end

  def newsletter_mailer
    @weekly_activities = []
    @weekly_activities << Post.joins(:teams).where("teams.created_at >= ?", Date.today - 7)
    @weekly_activities << Post.joins(:readings).where("readings.created_at >= ?", Date.today - 7)
    @weekly_activities = @weekly_activities.flatten
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
