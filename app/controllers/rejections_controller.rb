class RejectionsController < ApplicationController
  before_action :find_post
  before_action :find_rejection, only: [:destroy]

  def create
    if already_rejected?
      flash[:notice] = "Vous ne pouvez pas le faire plusieurs fois"
    else
      @post.rejections.create(user_id: current_user.id)
    end
    redirect_to post_path(@post)
  end

  def find_rejection
    @rejection = @post.rejections.find(params[:id])
  end

  def destroy
    if !(already_rejected?)
      flash[:notice] = "Vous ne pouvez pas le faire"
    else
      @rejection.destroy
    end
    redirect_to post_path(@post)
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def already_rejected?
    Rejection.where(user_id: current_user.id, post_id: params[:post_id]).exists?
  end
end
