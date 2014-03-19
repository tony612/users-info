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
end
