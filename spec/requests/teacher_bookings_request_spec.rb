require 'rails_helper'

RSpec.describe "TeacherBookings", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/teacher_bookings/index"
      expect(response).to have_http_status(:success)
    end
  end

end
