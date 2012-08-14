class Api::ScrapersController < ApplicationController
  respond_to :json

  def show
    url = params[:url]
    @response = Scraper.new(url).scrape
    respond_with @response
  end
end
