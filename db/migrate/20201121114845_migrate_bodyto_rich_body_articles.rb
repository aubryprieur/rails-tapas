class MigrateBodytoRichBodyArticles < ActiveRecord::Migration[6.0]
  def up
    Post.find_each do |post|
      post.update(rich_body: post.description)
    end
  end
end
