class Lesson < ApplicationRecord
  # After adding the video
  has_one_attached :video

  belongs_to :course
  has_many :lesson_users

  def previous_lesson
    course.lessons.where("position < ?", position).order(:position).last
  end

  def next_lesson
    course.lessons.where("position > ?", position).order(:position).first
  end
end
