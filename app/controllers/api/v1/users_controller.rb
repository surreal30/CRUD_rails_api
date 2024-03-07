class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]
  include Authentication


  # GET /users
  def index
    users = User.all
    if users
      render json: users
    end
  end

  # GET /users/1
  def show
    begin
      user = User.find(params[:id])
      render json: user, status: 200
    rescue
      render status: 404
    end
  end

  # POST /users
  def create
    unless request.headers[:username].present?
      password = create_password(params[:password])
      user = User.new(username: params[:username], password: password)

      if user.save
        render json: user, status: :created
      else
        render json: user.errors, status: :unprocessable_entity
      end
    else
      render status: 400
    end
  end

  # PATCH/PUT /users/1
  def update
    begin
      user = User.find(params[:id])
      if user.username == request.headers[:username]
        password = create_password(params[:password])
        if user.update(username: user_params[:username], password: password)
          render json: user, status: 200
        else
          render json: user.errors, status: :unprocessable_entity
        end
      else
        render status: 401
      end
    rescue
      render status: 404
    end
  end

  # DELETE /users/1
  def destroy
    begin
      user = User.find(params[:id])
      if user.username == request.headers[:username]
        user.destroy!
        render status: 204
      else
        render status: 401
      end
    rescue
      render status: 404
    end
  end

  def method_missing(m, *args, &block)
    render json: {data: "the method you searched is not here #{m}"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.permit(:username, :password)
    end
end
