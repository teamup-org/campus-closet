class SessionsController < ApplicationController
  def new
    # This action renders the login form
  end

  def create
    if params[:email].blank? || params[:password].blank?
      flash[:alert] = "Email and password cannot be blank."
      redirect_to login_path
      return
    end

    if request.env['omniauth.auth']
      auth = request.env['omniauth.auth']
      user = User.from_omniauth(auth)
    else
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to root_path, notice: 'Logged in successfully'
        return
      else
        flash[:alert] = "Invalid email or password."
        redirect_to login_path
        return
      end
    end

    if user.nil?
      flash[:alert] = "Invalid email or password."
      redirect_to login_path
    else
      # Check if the user is a new record (i.e., a new user)
      if user.student.nil?
        session[:user_id] = user.id
        redirect_to account_creation_user_url(user)
      else
        user.save if user.changed?
        session[:user_id] = user.id
        redirect_to root_path
      end
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end
end
