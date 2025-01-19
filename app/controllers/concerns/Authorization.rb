include Authentication

module Authorization
  def authorized?(object)
    if object.user_id == @user.id
      return true
    else
      return false
    end
  end
end