class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_own_comment, only: [:update, :destroy]

  def create
    body = comment_params[:body].to_s.strip
    return redirect_to(commentable_path, alert: "Votre message est vide.") if body.blank?

    # Anti-doublon : même message de la même personne sur le même AO il y a moins d'une minute
    # (double clic, page rechargée…) → on ne l'enregistre pas une deuxième fois.
    if @commentable.comments.where(user: current_user, body: body).where("created_at > ?", 1.minute.ago).exists?
      return redirect_to commentable_path
    end

    @comment = @commentable.comments.new(body: body, user: current_user)

    if @comment.save
      email_sent = EmailService.send_email_safe(
        ->(post, comment) { CommentMailer.creation_comment(post, comment) },
        @commentable, @comment
      )
      message = email_sent ? "Message envoyé, l'équipe a été prévenue par email." : "Message envoyé (notification par email momentanément indisponible)."
      redirect_to commentable_path, notice: message
    else
      redirect_to commentable_path, alert: "Impossible d'envoyer le message."
    end
  end

  def update
    body = comment_params[:body].to_s.strip
    if body.present? && @comment.update(body: body)
      redirect_to commentable_path(@comment), notice: "Message modifié."
    else
      redirect_to commentable_path(@comment), alert: "Le message ne peut pas être vide."
    end
  end

  def destroy
    @comment.destroy
    redirect_to commentable_path, notice: "Message supprimé."
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    @commentable = Post.find(params[:post_id])
  end

  # Seul l'auteur d'un message peut le modifier ou le supprimer (admins compris)
  def set_own_comment
    @comment = @commentable.comments.find(params[:id])
    return if @comment.user_id == current_user.id

    redirect_to commentable_path, alert: "Vous ne pouvez modifier ou supprimer que vos propres messages."
  end

  def commentable_path(comment = nil)
    post_path(@commentable, anchor: comment ? "commentaire-#{comment.id}" : "commentaires")
  end
end
