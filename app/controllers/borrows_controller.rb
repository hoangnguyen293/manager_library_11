class BorrowsController < ApplicationController
  before_action :check_login, only: :create
  before_action :load_book, only: :create

  def create
    @borrow = current_user.borrows.build borrow_params
    respond_to do |format|
      if @borrow.save
        format.js{flash.now[:success] = t(".borrowed_created")}
      else
        format.js{render :error_validate}
      end
    end
  end

  private

  def borrow_params
    params.require(:borrow).permit :borrowed_date, :returned_date, :book_id
  end

  def load_book
    @book = Book.find_by id: params[:borrow][:book_id]
    return if @book
    respond_to do |format|
      flash.now[:danger] = t(".not_found_book")
      format.js{render :create}
    end
  end

  def check_login
    return if logged_in?
    store_location
    flash[:danger] = t "application.please_log_in"
    redirect_to login_path
  end
end
