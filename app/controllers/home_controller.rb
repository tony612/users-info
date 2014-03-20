class HomeController < ApplicationController
  before_action :track_user, only: [:index]
  def index
  end

  def track_online_time
    if user_online?
      session[:user_tabs_count] -= 1
      unless user_online?
        # current_user.set_online(false)
        change_user_count(-1)

        update_user_time
        session[:online_user_time_begin] = Time.now
      end
    end
    if guest_online?
      # close a tab
      session[:guest_tabs_count] -= 1
      # Delete guest_id session only when all tabs are closed
      change_guest_count(-1) unless guest_online?
    end
    render nothing: true
  end

  protected

  def track_user
    if signed_in?
      track_login_user
    else
      track_guest
    end
  end

  def track_login_user
    session[:user_tabs_count] = user_tabs_count + 1
    if user_tabs_count == 1
      # current_user.set_online(true)
      change_user_count(1)
    else
      update_user_time
    end
    session[:online_user_time_begin] = Time.now
  end

  def track_guest
    session[:guest_tabs_count] = guest_tabs_count + 1
    change_guest_count(1) if guest_tabs_count == 1
  end

  def change_count(type, changed)
    type = type.to_s
    current_count = redis.get(type + '_count') || 0
    after_count = current_count.to_i + changed
    after_count = 0 if after_count < 0
    redis.set(type + '_count',  after_count)
  end

  def change_guest_count(changed)
    change_count('guest', changed)
  end

  def change_user_count(changed)
    change_count('user', changed)
  end

  def update_user_time
    begin_time = session[:online_user_time_begin]
    interval = Time.now - begin_time
    current_user.online_time += interval
    current_user.save
  end
end
