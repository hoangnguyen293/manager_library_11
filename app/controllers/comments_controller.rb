class CommentsController < ApplicationController
  before_action :check_login, only: :create
  before_action :load_book, only: :create

  def create
    @comment = current_user.comments.build comment_params
    respond_to do |format|
      if @comment.save
        format.js
      else
        format.js{render :error_validate}
      end
    end
  end

  private

  def comment_params
    params.permit :rate, :content, :book_id
  end

  def check_login
    return if logged_in?
    store_location
    flash[:danger] = t "application.please_log_in"
    redirect_to login_path
  end

  def load_book
    @book = Book.find_by id: params[:book_id]
    return if @book
    respond_to do |format|
      flash.now[:danger] = t("comments.not_found_book")
      format.js{render :error}
    end
  end
end
