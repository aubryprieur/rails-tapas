class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :readings, dependent: :destroy
  has_many :calls, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :rejections, dependent: :destroy

  has_one_attached :photo
  has_rich_text :rich_body

  validates_presence_of :deadline, :title, :client
end
