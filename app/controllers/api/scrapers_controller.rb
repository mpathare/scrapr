class Api::ScrapersController < ApplicationController
  respond_to :json

  def show
    options = params
    url = options.delete(:url)
    @response = Scraper.new(url).scrape(options)
    respond_with @response
  end
end
