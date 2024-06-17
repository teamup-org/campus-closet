# frozen_string_literal: true

class Auth0Controller < ApplicationController
  def failure
    # Handles failed authentication
    @error_msg = request.params['message']
      
    render plain: "Authentication failed: #{@error_msg}" if Rails.env.test?
  end
end


