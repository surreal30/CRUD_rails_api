class Api::V1::UsersController < ApplicationController
  include Authentication
  skip_before_action :get_user, only: [:create]

  # GET /users
  def index
    users = User.all
    if users
      render json: users, status: 200
    end
  end

  # GET /users/1
  def show
    if User.exists?(id: params[:id])
      user = User.find_by(id: params[:id])
      render json: user, status: 200
    else
      render json: {error: "No user found", error_code: 404}, status: 404
    end
  end

  # POST /users
  def create
    unless request.headers[:username].present?
      password = create_password(params[:password])
      user = User.new(username: params[:username], password: password)

      if user.save
        render json: user, status: 201
      else
        render json: user.errors, status: :unprocessable_entity
      end
    else
      render status: 400
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.username == request.headers[:username]
      password = create_password(params[:password])
      if @user.update!(user_params)
        render json: @user, status: 201
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render status: 401
    end
  end

  # DELETE /users/1
  def destroy
    if @user.username == request.headers[:username]
      @user.destroy!
      render status: 204
    else
      render status: 401
    end
  end

  def method_missing(m, *args, &block)
    render json: {data: "the method you searched is not here #{m}"}
  end

  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.permit(:username, :password)
    end
end
