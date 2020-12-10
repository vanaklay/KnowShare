require 'rails_helper'

RSpec.describe "TeacherLessons", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/teacher_lessons/index"
      expect(response).to have_http_status(:success)
    end
  end

end
