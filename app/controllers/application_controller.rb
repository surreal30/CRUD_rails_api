class ApplicationController < ActionController::API
  # include ActionController::Serialization
  before_action :get_user

  def get_user
    if User.exists?(username: request.headers[:username])
      @user = User.find_by(username: request.headers[:username])
    else
      render json: {error: "User not found", error_code: 404}, status: 404
    end
  end
end
