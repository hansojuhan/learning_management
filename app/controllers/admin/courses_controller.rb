class Admin::CoursesController < AdminController
  # 1. At the moment, this is not protected by authentication control
  # 2. Not using the admin layout
  # Solution: instead of inheriting from ApplicationController
  # Inherit from: AdminController

  def index
    @admin_courses = Course.all
  end

  def new
    @admin_course = Course.new
  end
  
end