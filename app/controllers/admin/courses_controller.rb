class Admin::CoursesController < ApplicationController
  def index
    @admin_courses = Course.all
  end

end