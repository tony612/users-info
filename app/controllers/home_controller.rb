class HomeController < ApplicationController
  before_action :track_user, only: [:index]
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
    if guest_online?
      # close a tab
      session[:guest_tabs_count] -= 1
      # Delete guest_id session only when all tabs are closed
      change_guest_count(-1) unless guest_online?
    end
    current_user.set_online(false) if current_user
    render nothing: true
  end

  protected

  def track_user
    if signed_in?
      track_login_user unless user_online?
      current_user.set_online(true)
    else
      track_guest
    end
  end

  def track_login_user
    session[:online_user_id] = current_user.id
    session[:online_user_time_begin] = Time.now
  end

  def track_guest
    session[:guest_tabs_count] = guest_tabs_count + 1
    change_guest_count(1) if guest_tabs_count == 1
  end

  def change_guest_count(changed)
    current_count = redis.get('guest_count') || 0
    after_count = current_count.to_i + changed
    after_count = 0 if after_count < 0
    redis.set('guest_count',  after_count)
  end
end
