class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :correct_user, only: %i(edit update)

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_your_mail"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t ".profile_update"
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def correct_user
    @user = User.find_by id: params[:id]
    return if @user && current_user?(@user)
    flash[:warning] = t "users.warning"
    redirect_to users_path
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end
end
