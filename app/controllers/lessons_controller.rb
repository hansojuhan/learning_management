class LessonsController < ApplicationController
  before_action :set_lesson, only: %i[ show update ]

  # This is the USER FACING controller, so they should not have power to edit, create, destroy 
  # This is user facing, so we do not want users to be able to destroy, update, create
  # All that will happen in a separate admin controller

  # GET /lessons/1 or /lessons/1.json
  def show
    @course = @lesson.course
  end

  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.find(params[:id])
    end
end
