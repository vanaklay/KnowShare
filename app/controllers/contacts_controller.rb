class ContactsController < ApplicationController

  def new
  end

  def create
    ContactMailer.send_contact_email(name: params[:name], email: params[:email], message: params[:message]).deliver_now
    redirect_to root_path, success: "Message envoyé !"
  end

end