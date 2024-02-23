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
  
  def create
    @admin_course = Course.new(course_params)

    if @admin_course.save
      redirect_to admin_courses_path
    else
      render :new
    end
  end

  private
    def course_params
      params.require(:course).permit(:title, :description, :premium_description, :paid, :stripe_price_id, :image)
    end
end