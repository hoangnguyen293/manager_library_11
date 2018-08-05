class Supports::Home
  def top_categories
    @top_categories = Category.list_category_top
  end

  def top_authors
    @top_authors = Author.list_author_top
  end

  def latest_books
    @books = Book.latest_books
  end
end
