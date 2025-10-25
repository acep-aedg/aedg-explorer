class SearchesController < ApplicationController
  def show
    @query = params[:q].to_s.strip

    @communities = Community.search(@query).limit(10)
    # @metadata    = Metadata.search(@query).limit(10)
    # @grids       = Grid.search(@query).limit(10)
  end

  def advanced
    # You can later add complex filters here
    @communities = Community.all.limit(10)
    # @metadata    = Metadata.all.limit(10)
    # @grids       = Grid.all.limit(10)
  end
end
