class SearchesController < ApplicationController
  def index
    @q = params[:q].to_s.strip
    @communities = @q.blank? ? Community.none : Community.search_full_text(@q)
    # @metadata    = @q.blank? ? Metadatum.none : Metadatum.search_full_text(@q).limit(20)
  end
end
