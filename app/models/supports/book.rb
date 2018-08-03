class Supports::Book
  def initialize book
    @book = book
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

  def related_books
    @related_books = Book.related_books @book.category_id, @book.id
  end

  def comments
    @comments = @book.comments.ordered_by_created_at
  end
end
