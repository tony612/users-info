class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :online_users, -> { where(is_online: true) }

  def set_online(is_online)
    self.is_online = is_online
    self.save!
  end
end
