class HardWorker
  include Sidekiq::Worker

  def initialize
    @user = User.first
    @amount = 100
  end

  def perform()
    p "*" * 100
    p "********First_job*******"
    Credit::Add.new(amount: @amount, user: @user)
    p "Congratulations #{User.first}, you just earned #{@amount} credits ! You have now #{@user.personal_credit} credit(s)!"
    p "********First_job*******"
    p "*" * 100
  end
end
