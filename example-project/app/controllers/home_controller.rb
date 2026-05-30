class HomeController < ApplicationController
  def index
    @projects_count = 12
    @unread_notifications = 3
  end
end
