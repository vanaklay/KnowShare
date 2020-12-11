require 'rails_helper'

RSpec.describe "LessonSearches", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/lesson_searches/index"
      expect(response).to have_http_status(:success)
    end
  end

end
