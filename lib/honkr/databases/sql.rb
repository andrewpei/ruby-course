require 'active_record'

module Honkr
  module Databases
    class SQL
      # Define models and relationships here (yes, classes within a class)
      class User < ActiveRecord::Base
        has_many :honks
      end

      class Honk < ActiveRecord::Base
        belongs_to :user
      end

      def persist_honk(honk)
        honk_row = Honk.create(user_id: honk.user_id, content: "#{honk.content}")
        honk.id = honk_row.id
      end

      def get_honk(honk_id)
        honk_row = Honk.find_by(id: honk_id)
        # binding.pry
        honk = Honkr::Honk.new(honk_row.id, honk_row.user_id, honk_row.content)
        return honk
      end

      def persist_user(user)
        binding.pry
        user_row = User.create(username: "#{user.username}", password_digest: "#{user.password_digest}")
        user.id = user_row.id
      end

      def get_user(user_id)
        user_row = User.find_by(id: user_id)
        # binding.pry
        user = Honkr::User.new(user_row.id, user_row.username, user_row.password_digest)
        # binding.pry
        return user
      end

      # def create_user(attrs)
      #   # NOTE the difference between the two `User` classes.
      #   # The first inherits from ActiveRecord, while
      #   # the second is your app's entity class
      #   ar_user = User.create(attrs)
      #   MyApp::User.new(ar_user.attributes)
      # end

    end
  end
end
