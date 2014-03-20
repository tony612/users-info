module ApplicationHelper
  def time_str(seconds)
    "#{seconds / 60} minutes, #{seconds % 60}"
  end
end
