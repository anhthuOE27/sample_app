class UsersController < ApplicationController
  before_action :logged_in_user, except: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def show
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controllers.users.show.warn"
    redirect_to root_path
  end

  def index
    @users = User.paginate page: params[:page], per_page: Settings.perpage
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t "controllers.users.create.welcome"
      log_in @user
      redirect_to @user
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t "controllers.users.update.update_messages"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controllers.users.destroy.deleted_messages"
    else
      flash[danger] = t "controllers.users.destroy.deleted_messages_fail"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controllers.users.logged_in_user.messages"
    redirect_to login_path
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
