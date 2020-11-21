class AddClientsToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :client, :string
  end
end
