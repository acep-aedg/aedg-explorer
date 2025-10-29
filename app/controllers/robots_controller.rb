# app/controllers/robots_controller.rb
class RobotsController < ApplicationController
  def index
    if Rails.env.production?
      render 'robots/production', formats: :text, content_type: 'text/plain'
    else
      render 'robots/development', formats: :text, content_type: 'text/plain'
    end
  end
end
