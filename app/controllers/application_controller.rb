class ApplicationController < ActionController::Base
  before_action :load_categories
  before_action :load_authors
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def load_categories
    @categories = Category.load_more 0
  end

  def load_authors
    @authors = Author.load_more 0
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "users.logged_in_user.please_log_in"
    redirect_to login_path
  end
end
