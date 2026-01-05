require 'test_helper'
require 'zip'

class DatasetTest < ActiveSupport::TestCase
  test 'attach_directory_as_zip creates a zip file and attaches it' do
    Dir.mktmpdir do |temp_dir|
      File.write(File.join(temp_dir, 'public_test_dataset.csv'), "id,name\n1,Test")
      File.write(File.join(temp_dir, 'public_test_dataset.json'), '{"id": 1, "name": "Test"}')
      File.write(File.join(temp_dir, 'public_test_dataset.yml'), "id: 1\nname: Test")

      dataset = datasets(:csv_dataset)
      dataset.archive.detach

      dataset.attach_directory_as_zip(temp_dir)

      assert dataset.archive.attached?, 'Archive should be attached'
      assert_equal 'application/zip', dataset.archive.content_type

      dataset.archive.open do |file|
        Zip::File.open(file) do |zip_file|
          # Verify CSV
          assert zip_file.find_entry('public_test_dataset.csv')
          assert_equal "id,name\n1,Test", zip_file.read('public_test_dataset.csv')

          # Verify JSON
          assert zip_file.find_entry('public_test_dataset.json')
          assert_equal '{"id": 1, "name": "Test"}', zip_file.read('public_test_dataset.json')

          # Verify YAML
          assert zip_file.find_entry('public_test_dataset.yml')
          assert_equal "id: 1\nname: Test", zip_file.read('public_test_dataset.yml')
        end
      end
    end
  end
end
