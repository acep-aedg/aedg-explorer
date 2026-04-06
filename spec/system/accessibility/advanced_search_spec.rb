require "rails_helper"

RSpec.describe "Accessibility::AdvancedSearch", type: :system do
  fixtures :all

  it "checks the advanced search page" do
    visit search_advanced_path
    expect_page_to_be_accessible
  end
end
