class UserCreditOrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user
  before_action :redirect_if_not_author
  before_action :all_users_orders

  def index
    respond_to do |format|
      format.html { }
      format.js { }
    end
  end

  private 
  
  def find_user
    @user = User.find(params[:user_id])
  end

  def redirect_if_not_author
    unless current_user == @user
      redirect_to current_user, warning: "Tu n'es pas le propriétaire de ce compte !"
    end
  end

  def all_users_orders
    @all_users_orders = @user.credit_orders
  end

end
