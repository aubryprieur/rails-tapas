desc 'weekly deletion of posts'
task weekly_deletion_of_posts: :environment do
  if Time.now.sunday?
    Post.where("deadline <?", Time.now).delete_all
  end
end
