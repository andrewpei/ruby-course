module Honkr
  class Honk

    attr_reader :user_id, :content
    attr_accessor :id

    def initialize(id, user_id, content)
      @id = id
      @user_id = user_id
      @content = content
    end
  end
end
