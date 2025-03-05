class BoroughsController < ApplicationController
  def index
    @boroughs = Borough.all
  end
end
