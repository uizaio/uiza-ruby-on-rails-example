Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "application#hello"
  post "/upload" => "application#uploadToAws"

  post "/live/stop" => "application#stopLive"
end
