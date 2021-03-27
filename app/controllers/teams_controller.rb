class TeamsController < ApplicationController
  before_action :find_post
  before_action :find_team, only: [:destroy]

  def create
    if already_in_team?
      flash[:notice] = "Vous ne pouvez pas être plusieurs fois dans l'équipe"
    else
      @post.teams.create(user_id: current_user.id)
    end
    redirect_to post_path(@post)
  end

  def find_team
    @team = @post.teams.find(params[:id])
  end

  def destroy
    if !(already_in_team?)
      flash[:notice] = "Vous ne pouvez pas vous retirer"
    else
      @team.destroy
    end
    redirect_to post_path(@post)
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def already_in_team?
    Team.where(user_id: current_user.id, post_id: params[:post_id]).exists?
  end
end
