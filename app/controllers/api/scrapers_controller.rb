class Api::ScrapersController < ApplicationController
  respond_to :json, :html

  def show
    respond_with Scraper.new(params[:url]).scrape(params)
  end
end
