class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def redis
    require "redis"
    redis ||= Redis.new
  end

  def guest_count
    redis.get('guest_count') || 0
  end
  helper_method :guest_count

  def user_count
    redis.get('user_count') || 0
  end
  helper_method :user_count

  def guest_online?
    guest_tabs_count > 0
  end

  def guest_tabs_count
    session[:guest_tabs_count] || 0
  end

  def user_online?
    user_tabs_count > 0
  end

  def user_tabs_count
    session[:user_tabs_count] || 0
  end
end
