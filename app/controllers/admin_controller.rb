class AdminController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @quick_stats = {
      sign_ups: User.where("created_at > ?", 1.week.ago).count,
      sales: CourseUser.where("created_at > ?", 1.week.ago).count,
      completed_lessons: LessonUser.where("created_at > ?", 1.week.ago).count,
      total_sign_ups: User.count
    }

    # This works with a gem called groupdate, gives "group by day"
    @completed_lessons_by_day = LessonUser.where("created_at > ?", 1.week.ago).where(completed: true).group_by_day(:created_at, format: "%A").count

    # Signups by day chart
    @sign_ups_by_day = User.where("created_at > ?", 1.week.ago).group_by_day(:created_at, format: "%A").count

    # Most popular courses
    @most_popular_courses = Course.joins(:course_users).group(:id).order('count(course_users.id) desc').limit(5)
  end
end