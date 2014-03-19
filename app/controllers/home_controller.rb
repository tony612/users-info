class HomeController < ApplicationController
  after_action :index, :track_users
  def index
  end

  def track_online_time
    if session[:online_user_time_begin]
      begin_time = session[:online_user_time_begin]
      interval = Time.now - begin_time
      current_user.online_time += interval
      current_user.save
      session[:online_user_time_begin] = Time.now
    end
    render nothing: true
  end

  protected

  def track_users
    if signed_in?
      unless session[:online_user_id]
        session[:online_user_id] = current_user.id
        session[:online_user_time_begin] = Time.now
      end
    else
    end
  end
end
