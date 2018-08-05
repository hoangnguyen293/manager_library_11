class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    check_activated user
  end

  private

  def check_activated user
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t ".account_activated"
    else
      flash[:danger] = t ".invalid_activation"
    end
    redirect_to root_url
  end
end
