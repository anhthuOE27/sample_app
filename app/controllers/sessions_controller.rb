class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      check_remember_me user
      redirect_to user
    else
      flash.now[:danger] = t "controllers.sessions.create.warn"
      render :new
    end
  end

  def check_remember_me user
    return remember user if params[:session][:remember_me] == Settings.remember
    forget user
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
