class CreditOrdersController < ApplicationController

  before_action :authenticate_user!
  before_action :find_amount, only: [:new, :create]
  before_action :number_of_credits_purchased, only: [:new, :create]
  before_action :amounts, only: [:create]

  def new

  end

  def create
    @credits = params[:data][:credits]
    @amount = params[:data][:amount]
    @stripe_amount = (@amount * 100).to_i

    begin
      customer = Stripe::Customer.create({
      email: params[:stripeEmail],
      source: params[:stripeToken],
      })
      charge = Stripe::Charge.create({
      customer: customer.id,
      amount: @stripe_amount,
      description: "Achat d'un produit",
      currency: 'eur',
      })
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_credit_order_path
    end
    
  end

  private

  def find_amount
    @amount = params[:data][:amount]
    
  end

  def number_of_credits_purchased
    @credits = params[:data][:credits]
  end

  def amounts # Make amount in eur, not in cent
    @stripe_amount = (@amount * 100).to_i
  end

end