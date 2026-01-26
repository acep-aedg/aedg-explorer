require "test_helper"
require "zip"

class MetadataControllerTest < ActionDispatch::IntegrationTest
  setup do
    @metadatum = oemetadata(:one)
  end

  test "should get index" do
    get metadata_url
    assert_response :success
  end

  test "should get show" do
    get metadatum_url(@metadatum)
    assert_response :success
  end

  test "should get search" do
    get search_metadata_url
    assert_response :success
  end

  test "should download metadatum/dataset archive via active storage" do
    dataset = @metadatum.dataset
    attach_virtual_zip(dataset)

    download_path = Rails.application.routes.url_helpers.rails_blob_path(
      dataset.archive,
      disposition: "attachment",
      only_path: true
    )

    get download_path

    assert_response :redirect

    follow_redirect!
    assert_response :success
    assert_match(/attachment/, response.headers["Content-Disposition"])
  end

  private

  # Helper to generate a valid zip in memory and attach it
  def attach_virtual_zip(dataset)
    stringio = Zip::OutputStream.write_buffer do |zio|
      zio.put_next_entry("test.txt")
      zio.write "This is a test text file"
    end
    stringio.rewind

    dataset.archive.attach(
      io: stringio,
      filename: "test_archive.zip",
      content_type: "application/zip"
    )
  end
end
