class ContactMailer < ApplicationMailer

  def send_contact_email(name:, email:, message:)
    @name = name
    @user_email = email
    @message = message
    mail(to: 'team.genepi.thp@gmail.com', subject: 'Un nouveau mail !') 
  end

end
