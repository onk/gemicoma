class UserAccount < ActiveRecord::Base
  belongs_to :user

  def save_auth_info(omniauth)
    self.raw_info  = omniauth.extra.raw_info.to_json
    self.save!
  end
end
