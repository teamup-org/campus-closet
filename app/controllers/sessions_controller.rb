# frozen_string_literal: true

# controller for the sessions
class SessionsController < ApplicationController
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
      redirect_to root_path, notice: "Welcome back, #{user.first}!"
    end
  end

  def destroy
    # Clear the session
    reset_session
    
    # Have user go through authentication 
    # Redirect to Auth0 logout 
    auth0_domain = ENV['AUTH0_DOMAIN']
    client_id = ENV['AUTH0_CLIENT_ID']
    return_to = root_url

    redirect_to "https://#{auth0_domain}/v2/logout?client_id=#{client_id}&returnTo=#{return_to}", allow_other_host: true
  end

  # def destroy
  #   session.delete(:user_id)
  #   redirect_to root_path
  # end
end
