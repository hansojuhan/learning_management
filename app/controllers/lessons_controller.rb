class LessonsController < ApplicationController
  before_action :set_lesson, only: %i[ show update ]
  before_action :set_course

  # This is the USER FACING controller, so they should not have power to edit, create, destroy 
  # This is user facing, so we do not want users to be able to destroy, update, create
  # All that will happen in a separate admin controller

  # GET /lessons/1 or /lessons/1.json
  def show
    @completed_lessons = current_user.lesson_users.where(completed:true).pluck(:lesson_id)
    @course = @lesson.course


  end
  
  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
    # Hit this if the "mark as completed" is pressed
  
    # When user opens a lesson, create a lesson_user if doesn't already exist
    @lesson_user = LessonUser.find_or_create_by(user: current_user, lesson: @lesson)
    # Set the boolean "completed" as true for the new lessonUser
    @lesson_user.update!(completed: true)
    # Get next lesson that is the lesson with a position greater than current
    next_lesson = @course.lessons.where("position > ?", @lesson.position).order(:position).first

    # If it was found, redirect to next lesson, if not, back to the course page
    if next_lesson
      redirect_to course_lesson_path(@course, next_lesson)
    else
      redirect_to course_path(@course), notice: "You've completed the course"
    end
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end
end
