class PostMailer < ApplicationMailer
  def creation_confirmation(post)
    @post = post
    mail_to_all_members(subject: "Nouvel appel d'offres · #{@post.client}")
  end
end
