class Course < ApplicationRecord
  # Defines an image for the course that we can access in views
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100,100]
  end

  # Access lessons variable on course object
  has_many :lessons
  # creates a direct many-to-many connection with another model
  has_and_belongs_to_many :categories

  has_many :course_users

  # Give the first lesson. This also needs positions to be added to Lesson.
  # We need this to determine which lesson comes first.
  def first_lesson
    self.lessons.order(:position).first
  end

  def next_lesson(current_user)
    # I have current lesson
    # It has position
    # Next has position + 1
    if current_user.blank?
      return first_lesson
    end

    completed_lessons = current_user.lesson_users.includes(:lesson).where(completed: true).where(lessons: {course_id: self.id })
    started_lessons = current_user.lesson_users.includes(:lesson).where(completed: false).where(lesson: { course_id: self.id }).order(:position)

    if started_lessons.any?
      return started_lessons
    end

    lessons = self.lessons.where.not(id: completed_lessons.pluck(:lesson_id)).order(:position)
    if lessons.any?
      lessons.first
    else
      return first_lesson
    end
  end
end
