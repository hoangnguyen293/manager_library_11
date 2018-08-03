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

  def categories
    @category = Category.list_category
  end

  def publishers
    @publishers = Publisher.list_publisher
  end

  def authors
    @authors = Author.list_author
  end
end
