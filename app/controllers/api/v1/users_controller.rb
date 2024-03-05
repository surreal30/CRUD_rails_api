class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]
  include Authentication


  # GET /users
  def index
    render json: {working: "yes"}, status: 200
    if authenticate_user

      users = User.all

      render json: users
    else
      render status: 401
    end
  end

  # GET /users/1
  def show
    render json: user
  end

  # POST /users
  def create
    unless request.headers[:username]
      password = create_password(params[:password])
      user = User.new(username: params[:username], password: password)

      if user.save
        render json: user, status: :created, location: user
      else
        render json: user.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    if user.update(user_params)
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    user.destroy!
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
      params.require(:user).permit(:username, :password)
    end
end
