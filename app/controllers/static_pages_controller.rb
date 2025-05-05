class StaticPagesController < ApplicationController
  def home
    @communities = Community.all
  end

  def about; end

  def user_guide
    @communities = Community.all
  end
end
