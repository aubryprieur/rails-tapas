class LikesController < ApplicationController
  before_action :find_post
  before_action :find_like, only: [:destroy]

  def create
    if already_liked?
      flash[:notice] = "Vous êtes déjà positionné·e sur cette réponse."
    else
      @post.likes.create(user_id: current_user.id)
      # Tentative d'envoi d'email avec gestion d'erreur
      EmailService.send_email_safe(
        ->(post, user) { LikeMailer.creation_like(post, user) },
        @post, current_user
      )
    end
    redirect_to post_path(@post)
  end

  def find_like
    @like = @post.likes.find(params[:id])
  end

  def destroy
    if !(already_liked?)
      flash[:notice] = "Action impossible."
    else
      @like.destroy
    end
    redirect_to post_path(@post)
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def already_liked?
    Like.where(user_id: current_user.id, post_id: params[:post_id]).exists?
  end

end
