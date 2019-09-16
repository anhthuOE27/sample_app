class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :show, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def show
    @user = User.find_by id: params[:id]
    @microposts = @user.microposts.paginate page: params[:page],
     per_page: Settings.perpage
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
      @user.send_activation_email
      flash[:info] = t "controllers.users.create.info"
      redirect_to root_path
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

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
