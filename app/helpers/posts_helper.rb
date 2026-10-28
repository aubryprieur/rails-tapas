module PostsHelper
  # Compte à rebours avant la date limite : { status:, label: }
  # status sert à la couleur : ok (vert), soon (orange), urgent (rouge), past (gris)
  def deadline_info(post)
    days = (post.deadline - Date.current).to_i
    status =
      if days.negative? then "past"
      elsif days <= 3 then "urgent"
      elsif days <= 7 then "soon"
      else "ok"
      end
    label =
      if days.negative? then "Échéance dépassée"
      elsif days.zero? then "Aujourd'hui"
      elsif days == 1 then "Demain"
      else "J-#{days}"
      end
    { status: status, label: label, days: days }
  end

  # Évite une requête par carte : on charge les favoris de l'utilisateur une seule fois.
  def favorited?(post)
    @favorite_post_ids ||= current_user.favorites.where(favorited_type: "Post").pluck(:favorited_id).to_set
    @favorite_post_ids.include?(post.id)
  end

  def new_post?(post)
    post.created_at >= 7.days.ago
  end

  def user_initials(user)
    [user.first_name, user.last_name].compact.map { |n| n.to_s.first }.join.upcase
  end
end
