class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit]

  def index
    @posts = Post.all
  end


  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to @post, notice: "L'appel d'offres vient d'être créé!"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  private

    def post_params
      params.require(:post).permit(:deadline, :title, :description, :photo)
    end

    def set_post
      @post = Post.find(params[:id])
    end



end
