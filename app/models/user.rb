class User < ApplicationRecord
  has_many :borrows, dependent: :destroy
  has_many :comments, dependent: :destroy
  before_save :downcase_email

  enum role: {user: 0, admin: 1, superadmin: 2}
  scope :ordered_by_created_at, ->{order created_at: :desc}
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: Settings.max_length_user}
  validates :email, presence: true,
    length: {maximum: Settings.max_length_user_email},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: Settings.min_length_user_password},
    allow_nil: true
  validates :role, inclusion: {in: %w(user admin)}

  private

  def downcase_email
    self.email = email.downcase
  end
end
