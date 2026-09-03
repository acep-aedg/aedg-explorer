class StaticPagesController < ApplicationController
  def home
    @communities = Community.all
  end

  def about; end

  def explore_all; end

  def user_guide
    @communities = Community.all
  end
end
