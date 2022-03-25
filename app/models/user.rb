class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email

  before_create :create_activation_digest

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

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
