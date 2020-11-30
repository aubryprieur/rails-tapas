class FavoritePostsController < ApplicationController
  before_action :set_post, only: [:create, :destroy]
  before_action :favorites

  def index
    @posts = current_user.favorite_posts.where('deadline >= ?', Date.today).order('deadline ASC')
  end

  def create
    if Favorite.create(favorited: @post, user: current_user)
      redirect_to posts_path, notice: "L'appel d'offres ' #{@post.title} ' à été ajouté dans vos favoris "
    else
      redirect_to posts_path, alert: "Something went wrong...*sad panda* "
    end
  end

  def destroy
    Favorite.where(favorited_id: @post.id, user_id: current_user.id).first.destroy
    redirect_to posts_path, alert: "L'appel d'offres ' #{@post.title} ' a été supprimé de vos favoris "
  end

  private

  def set_post
    @post = Post.find(params[:post_id] || params[:id])
  end

  def favorites
    @favorite_posts = current_user.favorite_posts
  end

end
