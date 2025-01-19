require 'bcrypt'

module Authentication
  def authenticate
    if User.exists?(username: request.headers[:username])
      user = User.find_by(username: request.headers[:username])
      if user && BCrypt::Password.new(user.password) == request.headers[:password]
        return true
      else
        render json: {error: "Unauthorized", error_code: "401"}, status: 401
      end
    else
      render json: {error: "User not found", error_code: 404}, status: 404
    end
  end

  def create_password(_password)
    return BCrypt::Password.create(_password)
  end
end