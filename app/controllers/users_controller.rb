class UsersController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!, except: [:create]
  before_action :find_user, :all_users
  before_action :redirect_not_author_to_dashboard, only: [:show, :edit, :update, :destroy]
  def show
  end

  def create
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to current_user, success: "Vos informations ont bien été mises à jour"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to @user, success: "Votre profil a bien été supprimé"
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :description)
  end
end
