class AddSubcriptionToPreviousUsers < ActiveRecord::Migration[5.2]
  def up
  	User.all.each do |user|
  		user.create_subscription
  	end
  end
end
