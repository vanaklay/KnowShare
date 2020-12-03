class HomeController < ApplicationController
  def index
    @lessons = Lesson.all
  end
end
