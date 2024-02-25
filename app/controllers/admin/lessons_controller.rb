class Admin::LessonsController < AdminController
  before_action :set_course
  # Define the lesson for drag n drop
  before_action :set_lesson, only: [:move, :show]

  def index
    @admin_lessons = @admin_course.lessons.order(:position)
  end

  def show
    # Lesson already provided by before action
  end
  
  # This Ruby on Rails controller action, move, is designed to change the order of 
  # lessons within a course, utilizing the acts_as_list gem. The acts_as_list gem 
  # provides a simple way to manage lists of ActiveRecord objects with ordering.
  def move
    # Reorder all of the lessons
    position = params[:position].to_i

    if position == 0
      @admin_lesson.move_to_top
    elsif position == @admin_course.lessons.count - 1
      @admin_lesson.move_to_bottom
    else
      @admin_lesson.insert_at(position + 1)
    end

    @admin_lesson.save!

    render json: { message: "success" }
  end

  def new
    @admin_lesson = @admin_course.lessons.new
  end
 
  def create
    @admin_lesson = @admin_course.lessons.new(lesson_params)
    if @admin_lesson.save
      flash[:success] = "Lesson successfully created"
      redirect_to admin_course_lessons_path(@admin_course)
    else
      flash[:error] = "Something went wrong"
      render :new
    end
  end
  

  private
    def lesson_params
      params.require(:lesson).permit(:title, :description, :videom, :paid, :position)
    end
    
    def set_course
      @admin_course = Course.find(params[:course_id])
    end

    def set_lesson
      @admin_lesson = @admin_course.lessons.find(params[:id])
    end
end
