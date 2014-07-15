module Honkr
  class SignIn
    def self.run(params)
      user = Honkr.db.get_user_by_username(params[:user_name])

      if user.nil?
        return {:success=> false, :error => :user_does_not_exist}
      end

      if !user.has_password?(params.delete(:password))
        return {:success? => false, :error => :invalid_password}
      end

      session_id = Honkr.db.create_session({:user_id => user.id})
      return {:success? => true, :session_id => session_id}
    end
  end
end