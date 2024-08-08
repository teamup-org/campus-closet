# frozen_string_literal: true

# controller for the application
class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def create_and_respond(model, redirect_url, params_method)
    instance_variable = instance_variable_set("@#{model.name.downcase}", model.new(send(params_method)))

    respond_to do |format|
      if instance_variable.save
        format.html do
          redirect_to send(redirect_url, instance_variable), notice: "#{model.name} was successfully created."
        end
        format.json { render :show, status: :created, location: instance_variable }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: instance_variable.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_and_respond(instance_variable, params_method)
    respond_to do |format|
      if instance_variable.update(send(params_method))
        format.html do
          redirect_to instance_variable, notice: "#{instance_variable.model_name.human} was successfully updated."
        end
        format.json { render :show, status: :ok, location: instance_variable }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: instance_variable.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_and_respond(instance_variable, redirect_url, model_name)
    instance_variable.destroy!

    respond_to do |format|
      format.html { redirect_to send(redirect_url), notice: "#{model_name.human} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
    @current_user = nil
  end

  def require_admin
    return if current_user&.admin?

    flash[:alert] = "You don't have permission to view this page."
    redirect_to root_path and return
  end
end
