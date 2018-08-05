class AuthorsController < ApplicationController
  before_action :load_author, only: :show

  def show
    @books = @author.books.paginate(page: params[:page],
      per_page: Settings.authors.books_per_page)
  end

  def load_more
    respond_to do |format|
      format.js do
        @authors = Author.load_more params[:id]
        @offset = params[:id]
      end
    end
  end

  private

  def load_author
    @author = Author.find_by id: params[:id]
    return if @author
    flash[:danger] = t "authors.not_found_author"
    redirect_to root_path
  end
end
