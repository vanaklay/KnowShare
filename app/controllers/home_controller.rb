class HomeController < ApplicationController

  def index
    if Lesson.all.length > 9
      @lessons = Lesson.all.sample(9)
    else
      @lessons = Lesson.all
    end

  end
  
end
