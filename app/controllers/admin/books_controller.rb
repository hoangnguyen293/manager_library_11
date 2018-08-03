class Admin::BooksController < Admin::ApplicationController
  before_action :load_book, except: %i(index new create)
  before_action :load_items, except: %i(index show destroy)

  def index
    @books = Book.paginate(page: params[:page],
      per_page: Settings.books_per_page)
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new book_params
    if @book.save
      flash[:sun] = t ".book_created"
      redirect_to admin_books_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @book.update_attributes(book_params)
      flash[:sun] = t ".book_updated"
      redirect_to admin_books_path
    else
      render :edit
    end
  end

  def destroy
    if @book.destroy
      flash[:sun] = t ".book_deleted"
    else
      flash[:lock] = t ".delete_failed"
    end
    redirect_to admin_books_path
  end

  private

  def load_items
    @support = Supports::Book.new @book
  end

  def load_book
    @book = Book.find_by id: params[:id]
    return if @book
    flash[:lock] = t "admin.books.not_found_book"
    redirect_to admin_books_path
  end

  def book_params
    params.require(:book).permit :name, :description, :detail, :edition,
      :pages, :category_id, :publisher_id, :author_id, :picture
  end
end
