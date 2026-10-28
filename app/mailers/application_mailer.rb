class ApplicationMailer < ActionMailer::Base
  # Expéditeur affiché « TAPAS ». L'adresse peut être changée sans toucher au code :
  #   heroku config:set MAIL_FROM="TAPAS <noreply@copas.coop>"
  # (l'adresse doit être autorisée dans SendGrid : expéditeur vérifié ou domaine authentifié)
  FROM = ENV.fetch("MAIL_FROM", "TAPAS <aubry.prieur@copas.coop>")

  default from: FROM
  layout "mailer"
  helper PostsHelper

  private

  # Les membres sont en copie cachée : personne ne voit la liste des adresses
  # et un « répondre à tous » n'écrit pas à toute l'équipe.
  def mail_to_all_members(subject:)
    mail(to: FROM, bcc: User.pluck(:email), subject: subject)
  end
end
