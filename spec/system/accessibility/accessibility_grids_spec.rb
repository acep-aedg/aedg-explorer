require 'rails_helper'

RSpec.describe "Accessibility::Grids", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it "checks the index page" do
    visit grids_path
    expect(page).to be_axe_clean
  end
end
