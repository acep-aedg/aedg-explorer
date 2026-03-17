require "rails_helper"

RSpec.describe "Accessibility::Grids", type: :system do
  fixtures :all

  before do
    @grid = grids(:one)
  end

  it "checks the index page" do
    visit grids_path
    expect_page_to_be_accessible
  end

  it "checks the general tab" do
    visit general_grid_path(@grid)
    expect_page_to_be_accessible
  end

  it "checks the power generation tab" do
    visit power_generation_grid_path(@grid)
    expect_page_to_be_accessible
  end
end
