class CreditOrderMailer < ApplicationMailer

  def send_email_confirm_credit_order(user, amount, credits)
    @user = user
    @amount = amount
    @credits = credits
    mail(to: @user.email, subject: 'Votre achat de crédits !') 
  end

end
