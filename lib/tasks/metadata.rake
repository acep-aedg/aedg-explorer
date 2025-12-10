require_relative 'import_helpers'

namespace :metadata do
  desc 'Download and Import metadata (Pass PR=123 to test a PR)'
  task import: :environment do
    Rake::Task['metadata:download_data'].invoke

    puts 'Starting metadata import...'
    filepath = Rails.root.join('db/imports/metadata')
    errors = Metadatum.import_metadata(filepath)

    if errors.any?
      puts "Import finished with errors:\n#{errors.join("\n")}"
    else
      puts 'Metadata import completed successfully.'
    end
  end

  desc 'Download data files (Defaults to DATA_POND_TAG, pass PR=123 for testing)'
  task download_data: [:environment] do
    ImportHelpers.download_data('data/public', Rails.root.join('db/imports/metadata').to_s)
  end

  desc 'Clear metadata records'
  task clear: [:environment] do
    puts 'Clearing metadata table...'
    Metadatum.destroy_all
  end
end
