class Admin::AuthorsController < Admin::ApplicationController
  before_action :load_author, except: %i(index new create)

  def index
    @authors = Author.paginate(page: params[:page],
      per_page: Settings.authors_per_page)
    store_location
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new author_params
    if @author.save
      flash[:sun] = t ".author_created"
      redirect_to admin_authors_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @author.update_attributes(author_params)
      flash[:sun] = t ".author_updated"
      redirect_back_or admin_authors_path
    else
      render :edit
    end
  end

  def destroy
    if @author.destroy
      flash[:sun] = t ".author_deleted"
    else
      flash[:lock] = t ".delete_failed"
    end
    redirect_back_or admin_authors_path
  end

  private

  def load_author
    @author = Author.find_by id: params[:id]
    return if @author
    flash[:lock] = t "admin.authors.not_found_author"
    redirect_to admin_authors_path
  end

  def author_params
    params.require(:author).permit :name, :description, :detail, :picture
  end
end
