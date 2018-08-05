class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      check_activated user
    else
      flash.now[:danger] = t ".invalid_account"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def check_activated user
    if user.activated?
      log_in user
      redirect_back_or root_path
    else
      message = t "sessions.account_not_activated"
      flash[:warning] = message
      redirect_to root_url
    end
  end
end
