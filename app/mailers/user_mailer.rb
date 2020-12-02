class UserMailer < ApplicationMailer
  default from: 'team.genepi.thp@gmail.com'
 
  def send_email_confirm_to_user(student, teacher)
    @student = student 
    @teacher = teacher
    mail(to: @student.email, subject: 'Votre cours est réservé !') 
  end

  def send_email_confirm_to_teacher(teacher, student)
    @student = student 
    @teacher = teacher
    mail(to: @teacher.email, subject: 'Un de vos cours est réservé !') 
  end
end
