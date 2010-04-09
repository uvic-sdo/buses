class TripsController < ApplicationController
	respond_to :html, :xml, :json

  def index
		respond_with(@trips = Route.all)
  end

	def show
		@trip = Trip.find params[:id] 
		respond_with(@trip)
	end

end
