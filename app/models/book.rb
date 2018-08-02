class Book < ApplicationRecord
  belongs_to :category
  belongs_to :author
  belongs_to :publisher
  default_scope{order created_at: :desc}
  scope :related_books, (lambda do |category_id, book_id|
    where("category_id = ? && id != ?", category_id, book_id)
      .limit(Settings.books.related_book_limit)
  end)
  mount_uploader :picture, PictureUploader
  validates :name, presence: true,
    length: {minimum: Settings.min_length_book,
             maximum: Settings.max_length_book}
  validates :description, presence: true,
    length: {minimum: Settings.min_length_book_description,
             maximum: Settings.max_length_book_description}
  validates :edition, presence: true,
    length: {minimum: Settings.min_length_book_edition,
             maximum: Settings.max_length_book_edition}
  validates :pages,
    numericality: {only_integer: true,
                   greater_than_or_equal_to: Settings.min_book_pages}
end
