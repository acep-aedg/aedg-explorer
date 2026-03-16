require 'rails_helper'

RSpec.describe "Accessibility::StaticPages", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it "checks the root page" do
    visit root_path
    expect(page).to be_axe_clean
  end

  it "checks the User Guide page" do
    visit user_guide_path
    expect(page).to be_axe_clean
  end

  it "checks the About page" do
    visit about_path
    expect(page).to be_axe_clean
  end
end
