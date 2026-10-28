class FavoritePostsController < ApplicationController
  before_action :set_post, only: [:create, :destroy]
  before_action :favorites

  def index
    @posts = current_user.favorite_posts.where('deadline >= ?', Date.today).order('deadline ASC')
                             .with_rich_text_rich_body.includes(:readings, :likes, :teams, photo_attachment: :blob)
  end

  def create
    if Favorite.find_or_create_by(favorited: @post, user: current_user).persisted?
      redirect_back_or_to posts_path, notice: "« #{@post.title} » a été ajouté à vos favoris."
    else
      redirect_back_or_to posts_path, alert: "Impossible d'ajouter cet appel d'offres à vos favoris."
    end
  end

  def destroy
    Favorite.where(favorited: @post, user: current_user).destroy_all
    redirect_back_or_to favorites_path, notice: "« #{@post.title} » a été retiré de vos favoris."
  end

  private

  def set_post
    @post = Post.find(params[:post_id] || params[:id])
  end

  def favorites
    @favorite_posts = current_user.favorite_posts
  end

end
