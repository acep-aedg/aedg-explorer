require "rails_helper"

RSpec.describe "Accessibility::StaticPages", type: :system do
  it "checks the root page" do
    visit root_path
    expect_page_to_be_accessible
  end

  it "checks the User Guide page" do
    visit user_guide_path
    expect_page_to_be_accessible
  end

  it "checks the About page" do
    visit about_path
    expect_page_to_be_accessible
  end

  it "checks the Explore All page" do
    visit explore_all_path
    expect_page_to_be_accessible
  end
end
