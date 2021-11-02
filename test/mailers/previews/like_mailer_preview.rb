# Preview all emails at http://localhost:3000/rails/mailers/like_mailer
class LikeMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/like_mailer/creation_like
  def creation_like
    LikeMailer.creation_like
  end

end
