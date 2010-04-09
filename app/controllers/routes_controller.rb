class RoutesController < ApplicationController
	respond_to :html, :xml, :json

  def index
		respond_with(@routes = Route.all)
  end

	def show
		@route = Route.find params[:id] 
		respond_with(@route)
	end
end
