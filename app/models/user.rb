class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_save :downcase_email

  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy

  enum role: {user: 0, admin: 1}

  validates :name, presence: true,
            length: {maximum: Settings.valid.length_50}
  validates :email, presence: true,
            length: {maximum: Settings.valid.length_255},
            format: {with: Settings.valid.email_regex},
            uniqueness: true
  validates :password, presence: true,
            length: {minimum: Settings.valid.length_6},
            allow_nil: true

  scope :newest, ->{order(created_at: :desc)}

  private

  def downcase_email
    email.downcase!
  end
end
