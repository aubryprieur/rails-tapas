class CallsController < ApplicationController
  before_action :find_post
  before_action :find_call, only: [:destroy]

  def create
    if already_called?
      flash[:notice] = "Vous ne pouvez pas le faire plus d'une fois."
    else
      @post.calls.create(user_id: current_user.id)
    end
    redirect_to post_path(@post)
  end

  def find_call
    @call = @post.calls.find(params[:id])
  end

  def destroy
    if !(already_called?)
      flash[:notice] = "Vous ne pouvez pas annuler l'action"
    else
      @call.destroy
    end
    redirect_to post_path(@post)
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def already_called?
    Call.where(user_id: current_user.id, post_id: params[:post_id]).exists?
  end
end
