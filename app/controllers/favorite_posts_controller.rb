class FavoritePostsController < ApplicationController
  before_action :set_post, only: [:create, :destroy]
  before_action :favorites

  # Calendrier mensuel des favoris (?month=2026-11)
  def index
    @month = begin
      Date.strptime(params[:month].to_s, "%Y-%m")
    rescue Date::Error
      Date.current
    end.beginning_of_month

    @calendar_start = @month.beginning_of_week(:monday)
    @calendar_end = @month.end_of_month.end_of_week(:monday)

    favorites = current_user.favorite_posts
    @posts_by_date = favorites.where(deadline: @calendar_start..@calendar_end)
                              .order(:deadline, :client).group_by(&:deadline)
    @upcoming_count = favorites.where("deadline >= ?", Date.current).count

    # Pour guider quand le mois affiché est vide
    @next_favorite = favorites.where("deadline > ?", @month.end_of_month).order(:deadline).first
    @previous_favorite = favorites.where("deadline < ? AND deadline >= ?", @month, Date.current).order(deadline: :desc).first
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
