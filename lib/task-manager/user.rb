class TM::User
  attr_reader :name, :user_id

  def initialize(uid, name)
    @user_id = uid
    @name = name
  end

end
