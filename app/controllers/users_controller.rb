class UsersController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!, except: [:create]
  before_action :find_user, :all_users
  before_action :redirect_not_author_to_dashboard, only: [:show, :edit, :update, :destroy]

  def show
  end
  
  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, success: "Vos informations ont bien été mises à jour"
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
    params.require(:user).permit(:first_name, :last_name, :description, :avatar)
  end

  def author?
    current_user.id == @user.id
  end

  def redirect_not_author_to_dashboard
    redirect_to current_user, danger: "Vous n'êtes pas le propriétaire de ce compte !" unless author?
  end
end
