class ReadingsController < ApplicationController
  before_action :find_post
  before_action :find_reading, only: [:destroy]

  def create
    if already_read?
      flash[:notice] = "vous ne pouvez pas valider plus d'une fois."
    else
      @post.readings.create(user_id: current_user.id)
    end
    redirect_to post_path(@post)
  end

  def find_reading
    @read = @post.readings.find(params[:id])
  end

  def destroy
    if !(already_read?)
      flash[:notice] = "Action impossible"
    else
      @read.destroy
    end
    redirect_to post_path(@post)
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def already_read?
    Reading.where(user_id: current_user.id, post_id: params[:post_id]).exists?
  end
end
