class SearchController < ApplicationController
  before_action :check_params, only: :index

  def index
    @books = Book.new.find_books(search_params).paginate(page: params[:page],
      per_page: Settings.search.books_per_page)
  end

  private

  def search_params
    params.require(:search).permit :name, :category_name,
      :author_name, :publisher_name
  end

  def check_params
    search_params
  rescue ActionController::ParameterMissing
    redirect_to root_path
  end
end
