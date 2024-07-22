# frozen_string_literal: true

# Controller for the sessions
class SessionsController < ApplicationController
  def new
    # This action renders the login form
  end

  def create
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(auth)

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

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end
end
