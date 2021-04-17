class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  def commentable_type=(class_name)
    super(class_name.constantize.base_class.to_s)
  end
end
