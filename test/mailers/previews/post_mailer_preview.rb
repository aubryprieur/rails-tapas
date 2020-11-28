# Preview all emails at http://localhost:3000/rails/mailers/post_mailer
class PostMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/post_mailer/new
  def creation_confirmation
    post = Post.last
    PostMailer.creation_confirmation(post)
  end

end
