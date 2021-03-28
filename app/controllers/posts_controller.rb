class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.where('deadline >= ?', Date.today).order('deadline DESC')
  end


  def new
    @post = Post.new
    authorize @post
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      PostMailer.creation_confirmation(@post).deliver_now
      redirect_to @post, notice: "L'appel d'offres vient d'être créé! "
    else
      render :new
    end
  end

  def show
    @users = User.all
    @user = current_user
    @comment = Comment.create
  end

  def edit
    authorize @post
  end

  def update
    authorize @post
    if @post.update(post_params)
      redirect_to @post, notice: "L'appel d'offres a été modifié "
    else
      render :edit
    end
  end

  def destroy
    authorize @post
    @post.photo.purge if @post.photo.attached?
    @post.delete
    if @post.destroy
      redirect_to posts_path, notice: "Appel d'offres supprimé "
    else
      render :new
    end
  end

  private

    def post_params
      params.require(:post).permit(:deadline, :title, :description, :photo, :client, :rich_body)
    end

    def set_post
      @post = Post.find(params[:id])
    end



end
