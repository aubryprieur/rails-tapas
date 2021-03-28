class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @commentable = commentable
    @comment = @commentable.comments.new
  end

  def create
    @commentable = commentable
    @comment = @commentable.comments.new(comment_params)
    if @comment.save
      redirect_to commentable_path(commentable), notice: "Votre commentaire a été créé avec succès."
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
