class BooksController < ApplicationController
  before_action :check_login, only: :show
  before_action :load_book, only: :show
  before_action :load_items, only: :show

  def show; end

  private

  def load_items
    @support = Supports::Book.new @book
  end

  def load_book
    @book = Book.find_by id: params[:id]
    return if @book
    flash[:danger] = t "books.not_found_book"
    redirect_to root_path
  end

  def check_login
    return if logged_in?
    store_location
    flash[:danger] = t "application.please_log_in"
    redirect_to login_path
  end
end
