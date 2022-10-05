class CommentMailer < ApplicationMailer
  default to: -> { User.pluck(:email) },
          from: 'aubry.prieur@copas.coop'

  def creation_comment(post, comment)
    @comment = comment
    @post = post

    mail(
      subject: "Nouveau commentaire sur Tapas "
    )
  end
end
