class PostMailer < ApplicationMailer
  default to: -> { User.pluck(:email) },
          from: 'aubry.prieur@copas.coop'

  def creation_confirmation(post)
    @post = post

    mail(
      subject: "Nouvel appel d'offres | #{@post.client}"
    )
  end
end
