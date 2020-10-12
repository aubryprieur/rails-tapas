class Post < ApplicationRecord
  validates_presence_of :deadline, :title, :description
end
