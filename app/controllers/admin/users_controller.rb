class UsersController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!
  before_action :redirect_if_user_not_admin
  before_action :find_user

  def show
  end
  
  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, success: "Les informations de cet utilisateur ont été mises à jour"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to @user, success: "Le profil de cet utilisateur a bien été supprimé"
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :description, :avatar)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
