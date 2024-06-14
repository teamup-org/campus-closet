# frozen_string_literal: true

# Controller for the user class
class UsersController < ApplicationController
  before_action :set_user, only: %i[show_student show_donor edit update destroy update_user]
  before_action :require_login, only: %i[show_student edit update_user]
  before_action :require_admin, only: %i[index new create make_admin]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.find(params[:id])
    unless current_user && (current_user == @user || current_user.admin?)
      redirect_to root_path
      flash[:alert] = 'You are not authorized to view this user.'
      return
    end
    render 'show'
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    session[:return_to] ||= request.referer
  end

  # POST /users or /users.json
  def create
    create_and_respond(User, :user_url, :user_params)
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    return unless @user.update(user_params)

    redirect_to @user, notice: 'Profile updated successfully.'
    # else
    #   render :edit
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    destroy_and_respond(@user, :users_url, User.model_name)
  end

  def account_creation
    @user = User.find(params[:id])

    return if @user.email.include?('tamu.edu')

    @user.update(donor: true)
  end

  def update_user
    return unless @user.update(user_params)

    @user.update(student: @user.email.include?('tamu.edu'))
    redirect_to root_path, notice: 'Account created successfully.'
    # else
    # render :edit
  end

  def show_student
    @user = User.find(params[:id])
    render 'show_student'
  end

  def show_donor
    @user = User.find(params[:id])
    render 'show_donor'
  end

  def make_admin
    @user = User.find(params[:id])
    if @user.update(admin: 'true')
      redirect_to users_path, notice: 'User successfully made admin.'
    else
      redirect_to users_path, alert: 'Failed to make user admin.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first, :last, :email, :phone, :address, :student, :donor, :admin)
  end

  def require_login
    return if current_user && current_user.id == @user.id

    flash[:alert] = "You don't have permission to view this profile."
    redirect_to root_path
  end
end
