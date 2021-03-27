class User < ApplicationRecord
  after_create :send_welcome_email
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :favorites
  has_many :favorite_posts, through: :favorites, source: :favorited, source_type: 'Post'
  has_many :likes, dependent: :destroy
  has_many :readings, dependent: :destroy
  has_many :calls, dependent: :destroy
  has_many :teams, dependent: :destroy

  validates_presence_of :first_name, :last_name

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end

end
