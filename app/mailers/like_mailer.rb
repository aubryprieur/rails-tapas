class LikeMailer < ApplicationMailer
  default to: -> { User.pluck(:email) },
          from: 'aubry.prieur@copas.coop'

  def creation_like(post)
    @post = post

    mail(
      subject: "Tapas | Une réponse à un appel d'offres se prépare !"
    )
  end
end
