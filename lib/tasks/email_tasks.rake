desc 'weekly newsletter email'
task weekly_newsletter_email: :environment do
  if Time.now.sunday?
    UserMailer.newsletter_mailer.deliver!
  end
end
