class PlacesController < ApplicationController
  def index
  end

  def show
    session[:name] = params[:name]
    session[:status] = params[:status]
    session[:street] = params[:street]
    session[:zip] = params[:zip]
    session[:city] = params[:city]
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end
