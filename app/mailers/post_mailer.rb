class PostMailer < ApplicationMailer
  default to: -> { User.pluck(:email) },
          from: 'aubry.prieur@copas.coop'

  def creation_confirmation(post)
    @post = post

    mail(
      subject: "post #{@post.client} created!"
    )
  end
end
