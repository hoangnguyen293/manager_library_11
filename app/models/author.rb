class Author < ApplicationRecord
  has_many :books, dependent: :destroy
  default_scope{order created_at: :desc}
  scope :list_author, ->{select :id, :name}
  mount_uploader :picture, PictureUploader
  scope :load_more, (lambda do |offset|
    order("created_at desc")
      .limit(Settings.authors.authors_menu_limit).offset(offset)
  end)
  scope :list_author_top, (lambda do
    joins(:books).select("authors.id, count(books.id), authors.name,
      authors.picture")
    .group("authors.id").order("count(books.id) DESC")
    .limit(Settings.homes.authors_in_page)
  end)
  validates :name, presence: true,
    length: {minimum: Settings.min_length_author,
             maximum: Settings.max_length_author}
  validates :description, presence: true,
    length: {minimum: Settings.min_length_author_description,
             maximum: Settings.max_length_author_description}
end
