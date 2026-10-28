class LikeMailer < ApplicationMailer
  # user : la personne qui vient de se positionner sur « Je réponds »
  def creation_like(post, user = nil)
    @post = post
    @user = user
    mail_to_all_members(subject: "Une réponse se prépare · #{@post.client}")
  end
end
