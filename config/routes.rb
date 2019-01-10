Rails.application.routes.draw do
  # get "big_blue_button/login"

  post "/" => "big_blue_button#join"
  post "big_blue_button/get_recordings" => "big_blue_button#get_recordings"

  root "big_blue_button#login"
end
