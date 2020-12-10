require 'rails_helper'

RSpec.describe "StudentBookings", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/student_bookings/index"
      expect(response).to have_http_status(:success)
    end
  end

end
