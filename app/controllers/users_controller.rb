class UsersController < ApplicationController
  respond_to :json, only: [:online_info]
  def online_info
    online_info = {users: User.online_users.count, strangers: guest_count}
    respond_with online_info.to_json
  end
end
