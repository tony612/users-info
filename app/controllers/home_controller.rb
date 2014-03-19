class HomeController < ApplicationController
  before_action :track_users, only: [:index]
  def index
    @online_users_count = User.online_users.count
  end

  def track_online_time
    if session[:online_user_time_begin]
      begin_time = session[:online_user_time_begin]
      interval = Time.now - begin_time
      current_user.online_time += interval
      current_user.save
      session[:online_user_time_begin] = Time.now
    end
    current_user.set_online(false) if current_user
    change_guest_count(-1) unless signed_in?
    render nothing: true
  end

  protected

  def track_users
    if signed_in?
      unless session[:online_user_id]
        session[:online_user_id] = current_user.id
        session[:online_user_time_begin] = Time.now
      end
      current_user.set_online(true)
    else
      change_guest_count(1)
    end
  end

  def change_guest_count(changed)
    current_count = redis.get('guest_count') || 0
    after_count = current_count.to_i + changed
    redis.set('guest_count',  after_count)
  end
end
