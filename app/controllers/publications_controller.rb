class PublicationsController < ApplicationController
	before_action :check_for_subscription, only: :show
	def index
		@publications = Publication.all
	end

	def show
		@publication = Publication.find(params[:id])
	end

	def check_for_subscription
		unless current_user.subscription.active
			respond_to do |format|
        format.html { redirect_to publications_path, notice: "You must be subscribed to access this content."}
      end
		end
	end
end