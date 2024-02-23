class LessonsController < ApplicationController
  before_action :set_lesson, only: %i[ show update ]
  before_action :set_course

  # Check if course is paid for first
  before_action :check_paid

  # This is the USER FACING controller, so they should not have power to edit, create, destroy 
  # This is user facing, so we do not want users to be able to destroy, update, create
  # All that will happen in a separate admin controller

  # GET /lessons/1 or /lessons/1.json
  def show
    @completed_lessons = current_user.lesson_users.where(completed:true).pluck(:lesson_id)
    @course = @lesson.course

    # Check if a course-user record exists for this user with this course
    # If yes, they have paid for it
    @paid_for_course = current_user.course_users.where(course: @course).exists?
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

    def check_paid
      # If lesson is paid and current user has not paid for it
      if @lesson.paid && !current_user.course_users.where(course_id: params[:course_id]).exists?

        # Redirect to the same page, if the previous lesson exists
        if @lesson.previous_lesson
          redirect_to course_lesson_path(@course, @lesson.previous_lesson), notice: "You must purchase the full course to access the next lesson"
        else
          redirect_to course_path(@course), notice: "You must purchase the full course to access the lesson"
        end

      end
    end
end
