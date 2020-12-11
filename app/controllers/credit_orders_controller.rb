class CreditOrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_amount, only: [:new, :create]
  before_action :all_users_orders, only: [:index]
  before_action :number_of_credits_purchased, only: [:new, :create]
  before_action :stripe_amount, only: [:create, :new]

  def index
  end 
  
  def new
  end

  def create
    begin
      customer = Stripe::Customer.create({
      email: params[:stripeEmail],
      source: params[:stripeToken],
      })
      charge = Stripe::Charge.create({
      customer: customer.id,
      amount: @stripe_amount,
      description: "Achat de crédits",
      currency: 'eur',
      })
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_credit_order_path
    end
    Credit::Add.new(amount: @credits.to_i, user: current_user).call
    CreditOrder.create(price: @amount.to_i, number_of_credit: @credits.to_i, user: current_user)
    CreditOrderMailer.send_email_confirm_credit_order(current_user, @amount, @credits).deliver_now

  end

  private

  def all_users_orders
    @all_users_orders = CreditOrder.where(user: current_user).all.sort.reverse
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
