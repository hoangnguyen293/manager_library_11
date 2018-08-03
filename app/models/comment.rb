class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :book
  scope :ordered_by_created_at, ->{order created_at: :desc}
  validates :content, presence: true,
    length: {maximum: Settings.comments.max_length_content}
  validates :rate,
    numericality: {only_integer: true,
                   greater_than_or_equal_to: Settings.comments.min_rate,
                   less_than_or_equal_to: Settings.comments.max_rate}
end
