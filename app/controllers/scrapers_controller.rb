class ScrapersController < ApplicationController
  respond_to :json

  def show
    url = params[:url]
    @response = Scraper.new.scrape(url)
    respond_with @response
  end
end
