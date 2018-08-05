class Admin::CommentsController < Admin::ApplicationController
  before_action :load_comment, only: :destroy

  def index
    @comments = Comment.ordered_by_created_at.paginate(page: params[:page],
      per_page: Settings.comments_per_page)
  end

  def destroy
    if @comment.destroy
      flash[:sun] = t ".comment_deleted"
    else
      flash[:lock] = t ".delete_failed"
    end
    redirect_to admin_comments_path
  end

  private

  def load_comment
    @comment = Comment.find_by id: params[:id]
    return if @comment
    flash[:lock] = t "admin.comments.not_found_comment"
    redirect_to admin_comments_path
  end
end
