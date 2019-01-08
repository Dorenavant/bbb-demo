Rails.application.routes.draw do
  # get "big_blue_button/login"

  post "/" => "big_blue_button#join"

  root "big_blue_button#login"
end
