require "rails_helper"

RSpec.describe "Accessibility::Communities", type: :system do
  fixtures :all

  before do
    driven_by(:selenium_chrome_headless)
    @community = communities(:one)
  end

  it "checks the index page" do
    visit communities_path
    expect(page).to be_axe_clean
  end

  it "checks the general tab" do
    visit general_community_path(@community)
    expect(page).to be_axe_clean
  end

  it "checks the power generation tab" do
    visit power_generation_community_path(@community)
    expect(page).to be_axe_clean
  end

  it "checks the electric rates sales tab" do
    visit electric_rates_sales_community_path(@community)
    expect(page).to be_axe_clean
  end

  it "checks the fuel tab" do
    visit fuel_community_path(@community)
    expect(page).to be_axe_clean
  end

  it "checks the demographics tab" do
    visit demographics_community_path(@community)
    expect(page).to be_axe_clean
  end

  it "checks the income tab" do
    visit income_community_path(@community)
    expect(page).to be_axe_clean
  end
end
