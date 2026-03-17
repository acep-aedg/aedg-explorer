require "rails_helper"

RSpec.describe "Accessibility::DataExplorers", type: :system do
  fixtures :oemetadata
  before do
    driven_by(:selenium_chrome)
    @metadatum = oemetadata(:one)
  end

  it "checks the search page" do
    visit search_metadata_path
    expect(page).to be_axe_clean
  end

  it "checks the metadata page" do
    visit metadata_path
    expect(page).to be_axe_clean
  end

  it "checks the metadatum page" do
    visit metadatum_path(@metadatum)
    expect(page).to be_axe_clean
  end
end
