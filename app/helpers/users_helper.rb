module UsersHelper
  def find_user
    @user = User.find_by(username: params[:username])
  end

  def all_users
    @users = User.all.sort
  end
end
