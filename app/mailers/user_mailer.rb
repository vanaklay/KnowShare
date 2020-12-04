class UserMailer < ApplicationMailer
  default from: 'team.genepi.thp@gmail.com'

  def welcome_send(user)
    @user = user
    mail(to: @user.email, subject: 'Bienvenue chez KnowShare !') 
  end
 
end
