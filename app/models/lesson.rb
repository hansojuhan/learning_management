class Lesson < ApplicationRecord
  # After adding the video
  has_one_attached :video

  belongs_to :course
end
