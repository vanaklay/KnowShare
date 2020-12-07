class HardWorker
  include Sidekiq::Worker

  def perform()
    p "********hi!*******"
  end
end
