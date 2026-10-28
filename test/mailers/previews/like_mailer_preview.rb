# Aperçu : http://localhost:3000/rails/mailers/like_mailer
class LikeMailerPreview < ActionMailer::Preview
  def creation_like
    LikeMailer.creation_like(Post.last, User.first)
  end
end
