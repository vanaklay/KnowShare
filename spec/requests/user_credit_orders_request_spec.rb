require 'rails_helper'

RSpec.describe "UserCreditOrders", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/user_credit_orders/index"
      expect(response).to have_http_status(:success)
    end
  end

end
