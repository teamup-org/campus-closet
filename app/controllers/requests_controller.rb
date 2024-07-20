# frozen_string_literal: true

# controller for the requests
class RequestsController < ApplicationController
  before_action :set_request, only: %i[show edit update destroy]
  before_action :require_admin, only: %i[index]

  # GET /requests or /requests.json
  def index
    @requests = Request.all
  end

  # GET /requests/1 or /requests/1.json
  def show; end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit; end

  # POST /requests or /requests.json
  # def create
  #   create_and_respond(Request, :request_url, :request_params)
  # end

  def create
    create_and_respond(Request, :request_url, :request_params)
  end

  # PATCH/PUT /requests/1 or /requests/1.json
  def update
    update_and_respond(@request, :request_params)
  end

  # DELETE /requests/1 or /requests/1.json
  def destroy
    destroy_and_respond(@request, :requests_url, Request.model_name)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = Request.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def request_params
    params.require(:request).permit(:donor_id, :receiver_id, :item_id, :time_slot_id, :message)
  end
end
