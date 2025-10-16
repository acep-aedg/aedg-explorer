# app/controllers/communities/summaries_controller.rb
module Communities
  class SummariesController < Shared::BaseSummariesController
    before_action :set_community

    private

    def set_community = @community = Community.friendly.find(params[:community_id])
    def owner = @community
  end
end
