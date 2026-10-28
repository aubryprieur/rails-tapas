# Aperçu : http://localhost:3000/rails/mailers/comment_mailer
class CommentMailerPreview < ActionMailer::Preview
  def creation_comment
    post = Post.last
    comment = post.comments.last || post.comments.new(body: "On a déjà travaillé avec eux, je peux reprendre la note méthodo.", user: User.first)
    CommentMailer.creation_comment(post, comment)
  end
end
