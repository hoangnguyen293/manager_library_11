class Book < ApplicationRecord
  has_many :borrows, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :category
  belongs_to :author
  belongs_to :publisher
  scope :related_books, (lambda do |category_id, book_id|
    where("category_id = ? && id != ?", category_id, book_id)
      .limit(Settings.books.related_book_limit)
  end)
  scope :books_for_top_category, (lambda do
    order("created_at desc").limit(Settings.books.books_for_top_category)
  end)
  scope :latest_books, (lambda do
    order("created_at desc").limit(Settings.books.latest_books_limit)
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

  def find_books search_params
    @books = Book.joins(:category, :author, :publisher).order("created_at desc")
    find_books_by_name search_params[:name]
    find_books_by_category search_params[:category_name]
    find_books_by_author search_params[:author_name]
    find_books_by_publish search_params[:publisher_name]
    @books
  end

  private

  def find_books_by_name name
    return unless name.present?
    @books = @books.where("books.name like ?", "%" + name + "%")
  end

  def find_books_by_category category_name
    return unless category_name.present?
    @books = @books.where("categories.name like ?", "%" + category_name + "%")
  end

  def find_books_by_author author_name
    return unless author_name.present?
    @books = @books.where("authors.name like ?", "%" + author_name + "%")
  end

  def find_books_by_publish publisher_name
    return unless publisher_name.present?
    @books = @books.where("publishers.name like ?", "%" + publisher_name + "%")
  end
end
