class Api::ScrapersController < ApplicationController
  respond_to :json, :html

  def show
    @response = Scraper.new(params[:url]).scrape(params)
    respond_with @response
  end
end
