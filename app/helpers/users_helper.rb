module UsersHelper
  def find_user
    @user = User.find(params[:id])
  end

  def all_users
    @users = User.all.sort
  end

  def author?
    current_user.id == @user.id
  end

  def redirect_not_author_to_dashboard
    redirect_to current_user, danger: "Vous n'êtes pas le propriétaire de ce compte !" unless author?
  end
end
