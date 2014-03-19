class AddOnlineTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :online_time, :float, default: 0
  end
end
