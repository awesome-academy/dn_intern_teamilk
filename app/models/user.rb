class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :validatable, :trackable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

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

  def self.from_omniauth access_token
    data = access_token.info
    user = User.find_by email: data["email"]

    return user if user

    User.create(name: data["name"],
      email: data["email"],
      password: Devise.friendly_token[0, 20],
      uid: access_token[:uid],
      provider: access_token[:provider])
  end

  private

  def downcase_email
    email.downcase!
  end
end
