class EmailService
  def self.send_email(mailer_method, *args)
    begin
      mailer_method.call(*args).deliver_now
      { success: true, message: "Email envoyé avec succès" }
    rescue StandardError => e
      Rails.logger.error "Erreur envoi email: #{e.message}"
      { success: false, message: "Impossible d'envoyer l'email actuellement" }
    end
  end

  def self.send_email_safe(mailer_method, *args)
    begin
      mailer_method.call(*args).deliver_now
      true
    rescue StandardError => e
      Rails.logger.error "Erreur envoi email: #{e.message}"
      false
    end
  end
end
