class Course < ApplicationRecord
  # Defines an image for the course that we can access in views
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100,100]
  end

  # Access lessons variable on course object
  has_many :lessons
  # creates a direct many-to-many connection with another model
  has_and_belongs_to_many :categories
end
