class HomeController < ApplicationController
  after_action :index, :track_users
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
    end
  end
end
