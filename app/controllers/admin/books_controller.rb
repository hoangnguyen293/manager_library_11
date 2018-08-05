class Admin::BooksController < Admin::ApplicationController
  before_action :load_book, except: %i(index new create search)
  before_action :load_items, except: %i(index show destroy search)
  before_action :check_params, only: :search

  def index
    @books = Book.paginate(page: params[:page],
      per_page: Settings.books_per_page)
    store_location
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
      redirect_back_or admin_books_path
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
    redirect_back_or admin_books_path
  end

  def search
    @books = Book.new.find_books(search_params).paginate(page: params[:page],
      per_page: Settings.books_per_page)
    store_location
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

  def search_params
    params.require(:search).permit :name, :category_name,
      :author_name, :publisher_name
  end

  def check_params
    search_params
  rescue ActionController::ParameterMissing
    redirect_to admin_books_path
  end
end
