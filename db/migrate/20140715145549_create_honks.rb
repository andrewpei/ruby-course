class CreateHonks < ActiveRecord::Migration
  def change
    create_table :honks do |c|
      c.integer :user_id
      c.string :content
    end

  end
end