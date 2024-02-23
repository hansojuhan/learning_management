class Lesson < ApplicationRecord
  # After adding the video
  # This also adds a thumbnail for the video
  has_one_attached :video do |attachable|
    attachable.variant :thumb, resize_to_limit: [500,500]
  end

  belongs_to :course
  has_many :lesson_users
end
