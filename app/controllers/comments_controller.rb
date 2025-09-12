class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @commentable = commentable
    @comment = @commentable.comments.new
  end

  def create
    @commentable = commentable
    @comment = @commentable.comments.new(comment_params)
    @post = Post.find(params[:post_id])

    if @comment.save
      # Tentative d'envoi d'email avec gestion d'erreur
      email_sent = EmailService.send_email_safe(
        ->(post, comment) { CommentMailer.creation_comment(post, comment) },
        @post, @comment
      )

      success_message = if email_sent
        "Votre commentaire a été créé avec succès et les utilisateurs ont été notifiés !"
      else
        "Votre commentaire a été créé avec succès ! (Notification par email temporairement indisponible)"
      end

      redirect_to commentable_path(commentable), notice: success_message
    else
      # Si le commentaire ne se sauvegarde pas, afficher les erreurs
      redirect_to commentable_path(commentable), alert: "Erreur lors de la création du commentaire."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id, :commentable_id, :commentable_type)
  end

  def commentable
    if params[:post_id]
      id = params[:post_id]
      Post.find(params[:post_id])
    else
      id = params[:user_id]
      User.find(params[:user_id])
    end
  end

  def commentable_path(commentable)
    if Post === commentable
      post_path(commentable.id, commentable)
    else
      user_path(commentable)
    end
  end
end
