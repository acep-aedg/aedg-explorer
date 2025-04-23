class StaticPagesController < ApplicationController
  def home
    @communities = Community.all
  end

  def about
  end

  def user_guide
  end
end
