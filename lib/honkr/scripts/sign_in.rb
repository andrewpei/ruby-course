module Honkr
  class SignIn
    def self.run(params)
      user = Honkr.db.get_user_by_username(params[:user_name])
      session_id = Honkr.db.create_session({:user_id => user.id})
      
      if user.has_password?(params[:password])
        return {:success? => true, :session_id => session_id} 
      end

      {:success? => false, :error => :invalid_password}
    end
  end
end