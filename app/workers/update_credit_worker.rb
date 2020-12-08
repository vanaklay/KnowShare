class UpdateCreditWorker
  include Sidekiq::Worker

  def perform
    @user = User.first
    @amount = 100
    p "*" * 100
    p "********First_job*******"
    Credit::Add.new(amount: @amount, user: @user).call
    p "Congratulations #{@user.username}, you just earned #{@amount} credits ! You have now #{@user.personal_credit} credit(s)!"
    p "********First_job*******"
    p "*" * 100
  end
end
