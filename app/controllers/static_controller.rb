class StaticController < ApplicationController
  def homepage
    open_posts = Post.where("deadline >= ?", Date.current)
    with_details = ->(scope) { scope.with_rich_text_rich_body.includes(:readings, :likes, :teams, photo_attachment: :blob) }

    @open_count = open_posts.count
    @closing_soon_count = open_posts.where("deadline <= ?", Date.current + 7).count
    @favorites_count = current_user.favorite_posts.where("deadline >= ?", Date.current).count
    # AO en cours sur lesquels je suis positionné·e (lecture, appel, réponse ou équipe)
    @my_positions_count = [Reading, Call, Like, Team].flat_map { |model|
      model.joins(:post).where(user: current_user).where("posts.deadline >= ?", Date.current).pluck(:post_id)
    }.uniq.size

    @closing_soon = with_details.call(open_posts.order(deadline: :asc).limit(3))
    @latest = with_details.call(open_posts.order(created_at: :desc).limit(3))
  end
end
