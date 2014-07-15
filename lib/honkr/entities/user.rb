module Honkr
  class User

    attr_reader :username, :password_digest
    attr_accessor :id

    def initialize(id, username, password_digest=nil)
      @id = id
      @username = username
      @password_digest = password_digest
    end

    def update_password(password)
      @password_digest = Digest::SHA2.hexdigest(password)
    end

    def has_password?(password)
      Digest::SHA2.hexdigest(password) == @password_digest
    end
  end
end