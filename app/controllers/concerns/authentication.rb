require 'bcrypt'

module Authentication
  def authenticate
    user = User.find_by(username: request.headers[:username])
    if user && BCrypt::Password.new(user.password) == request.headers[:password]
      return true
    else
      render json: {error: "Unauthorized", error_code: "401"}, status: 401
    end
  end

  def create_password(_password)
    return BCrypt::Password.create(_password)
  end
end