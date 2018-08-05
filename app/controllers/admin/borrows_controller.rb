class Admin::BorrowsController < Admin::ApplicationController
  before_action :load_borrow, only: %i(show edit destroy)
  before_action :check_waiting_status, only: :show
  before_action :check_sent_status, only: :edit
  before_action :check_params, only: :search

  def index
    @borrows = Borrow.ordered_by_created_at.paginate(page: params[:page],
      per_page: Settings.borrows_per_page)
    store_location
  end

  def show
    begin
      @borrow.send_acceptance_email
      if @borrow.update_attributes(status: Borrow.statuses.key(1))
        flash[:sun] = t ".email_sent"
      else
        flash[:lock] = t ".update_fail"
      end
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy,
      Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError
      flash[:lock] = t "mailer.error_email_sent"
    end
    redirect_back_or admin_borrows_path
  end

  def edit
    if @borrow.update_attributes(status: Borrow.statuses.key(2),
        real_borrowed_date: Time.zone.now)
      flash[:sun] = t ".borrowed_success"
    else
      flash[:lock] = t ".borrow_fail"
    end
    redirect_back_or admin_borrows_path
  end

  def destroy
    if @borrow.destroy
      flash[:sun] = t ".borrow_deleted"
    else
      flash[:lock] = t ".borrow_failed"
    end
    redirect_back_or admin_borrows_path
  end

  def search
    @borrows = Borrow.new.find_borrows(search_params)
                     .paginate(page: params[:page],
                        per_page: Settings.borrows_per_page)
    store_location
  end

  private

  def load_borrow
    @borrow = Borrow.find_by id: params[:id]
    return if @borrow
    flash[:lock] = t "admin.borrows.not_found_borrow"
    redirect_to admin_borrows_path
  end

  def check_waiting_status
    return if @borrow.waiting?
    flash[:lock] = t "admin.borrows.error_email_sent"
    redirect_to admin_borrows_path
  end

  def check_sent_status
    return if @borrow.sent?
    flash[:lock] = t "admin.borrows.error_borrowed"
    redirect_to admin_borrows_path
  end

  def search_params
    params.require(:search).permit :email, :book_name
  end

  def check_params
    search_params
  rescue ActionController::ParameterMissing
    redirect_to admin_borrows_path
  end
end
