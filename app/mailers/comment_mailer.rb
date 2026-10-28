class CommentMailer < ApplicationMailer
  def creation_comment(post, comment)
    @post = post
    @comment = comment
    mail_to_all_members(subject: "Nouveau commentaire · #{@post.client}")
  end
end
