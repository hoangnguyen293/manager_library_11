class CategoriesController < ApplicationController
  before_action :load_category, only: :show
  before_action

  def show
    respond_to do |format|
      format.html do
        @books = @category.books.paginate(page: params[:page],
          per_page: Settings.categories.books_per_page)
      end
      format.js{@books = @category.books.books_for_top_category}
    end
  end

  def load_more
    respond_to do |format|
      format.js do
        @categories = Category.load_more params[:id]
        @offset = params[:id]
      end
    end
  end

  private

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category
    flash[:danger] = t "categories.not_found_category"
    redirect_to root_path
  end
end
