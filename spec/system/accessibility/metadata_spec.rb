require "rails_helper"

RSpec.describe "Accessibility::Metadata", type: :system do
  fixtures :oemetadata

  before do
    @metadatum = oemetadata(:one)
  end

  it "checks the search page" do
    visit search_metadata_path
    expect_page_to_be_accessible
  end

  it "checks the metadata page" do
    visit metadata_path
    expect_page_to_be_accessible
  end

  it "checks the metadatum page" do
    visit metadatum_path(@metadatum)
    expect_page_to_be_accessible
  end
end
