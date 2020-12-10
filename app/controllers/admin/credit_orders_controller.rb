class Admin::CreditOrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_user_not_admin
  before_action :find_all_orders, only: [:index]
  before_action :find_amount, only: [:index]
  before_action :number_of_credits_purchased, only: [:index]
  before_action :stripe_amount, only: [:index]

  def index
  end 
  
  private

  def find_all_orders
    @orders = CreditOrder.all.sort.reverse
  end 

  def find_amount
    @amount = params[:amount]
  end

  def number_of_credits_purchased
    @credits = params[:credits]
  end

  def stripe_amount # Make amount in eur, not in cent
    @stripe_amount = @amount.to_i * 100
  end
end