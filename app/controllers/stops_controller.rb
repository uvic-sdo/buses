class StopsController < ApplicationController
	respond_to :html, :xml, :json

  def index
		respond_with(@stops = Route.all)
  end

	def show
		@stop = Stop.find params[:id] 
		respond_with(@stop)
	end

end
