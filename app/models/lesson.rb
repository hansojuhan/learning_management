class Lesson < ApplicationRecord
  # After adding the video
  # This also adds a thumbnail for the video
  has_one_attached :video do |attachable|
    attachable.variant :thumb, resize_to_limit: [500,500]
  end

  # This tells lesson that it has access to acts as list method
  acts_as_list

  belongs_to :course
  has_many :lesson_users

  def previous_lesson
    course.lessons.where("position < ?", position).order(:position).last
  end

  def next_lesson
    course.lessons.where("position > ?", position).order(:position).first
  end
end
