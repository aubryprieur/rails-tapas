# Aperçu : http://localhost:3000/rails/mailers/post_mailer
class PostMailerPreview < ActionMailer::Preview
  def creation_confirmation
    PostMailer.creation_confirmation(Post.last)
  end
end
