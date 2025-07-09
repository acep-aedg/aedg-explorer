namespace :metadata do
  desc 'Download metadata files'
  task download: :environment do
    repo_url = ENV.fetch('GH_METADATA_REPO_URL', 'https://github.com/acep-aedg/aedg-data-pond')

    folder_path = 'data/public'
    local_dir = Rails.root.join('db/imports/metadata').to_s

    # Ensure the local directory & keep file exists
    FileUtils.mkdir_p(local_dir)

    Dir.mktmpdir do |temp_dir|
      system("git clone --filter=blob:none --no-checkout #{repo_url} #{temp_dir}")

      Dir.chdir(temp_dir) do
        # Enable sparse-checkout
        system('git sparse-checkout init --cone')
        system("git sparse-checkout set #{folder_path}")
        system('git checkout main')
        # Sync only new/updated files
        system("rsync -avh --delete #{folder_path}/ #{local_dir}/")
      end
    end
  end

  desc 'Import metadata files'
  task import: %i[environment download] do
    puts 'Starting metadata import'
    filepath = Rails.root.join('db/imports/metadata')
    errors = Metadatum.import_metadata(filepath)
    puts errors.join("\n")
    puts 'Metadata import completed'
  end

  desc 'Clear metadata records'
  task clear: :environment do
    Metadatum.destroy_all
  end
end
