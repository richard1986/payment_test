class UsersController < ApplicationController
  before_action :authenticate_user!
  # attr_accessor :stripe_card_token
  skip_before_action :verify_authenticity_token
  def info
  	@subscription = current_user.subscription

  	if @subscription.active 
  		@stripe_customer = Stripe::Customer.retrieve(@subscription.stripe_user_id)
  		@stripe_subscription = @stripe_customer.subscriptions.first
  	end
  end

  def cancel_subscription
  	@stripe_customer = Stripe::Customer.retrieve(@subscription.stripe_user_id)
  	@stripe_subscription = @stripe_customer.subscriptions.first

  	@stripe_subscription.delete
  	current_user.subscription.active = false
  	current_user.subscription.save
  	redirect_to users_info_path
  end

  def charge
  	token = params[:stripeToken]
  	customer = Stripe::Customer.create(
  		source: token,
  		email: current_user.email,
  		# id: 'sub_FtvgBB08Ke4dOn'
  	)

  	current_user.subscription.stripe_user_id = customer.id
  	current_user.subscription.active = true
  	current_user.subscription.save

  	redirect_to users_info_path
  end	
end
