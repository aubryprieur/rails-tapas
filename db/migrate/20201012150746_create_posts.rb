class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.date :deadline
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
