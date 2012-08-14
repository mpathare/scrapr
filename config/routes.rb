Scrapr::Application.routes.draw do
  namespace :api do
    resource :scrapers, :only => [:show]
  end
end
