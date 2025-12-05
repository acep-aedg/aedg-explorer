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

  desc 'Test download files from a specific GitHub PR (TEMP for testing)'
  task test_pr_download: :environment do
    repo_url   = ENV.fetch('GH_DATA_REPO_URL', 'https://github.com/acep-aedg/aedg-data-pond')
    pr_number  = 49 # <<< TEMP: hardcode the PR you want to test
    folder_path = 'data/public'
    local_dir   = Rails.root.join('db/imports/metadata').to_s

    # Ensure the local directory & keep file exists
    FileUtils.mkdir_p(local_dir)
    keep_file = File.join(local_dir, '.keep')
    FileUtils.touch(keep_file) unless File.exist?(keep_file)

    Dir.mktmpdir do |temp_dir|
      # Clone the repo without checking out a branch yet
      system("git clone --no-checkout #{repo_url} #{temp_dir}") or
        raise "Failed to clone #{repo_url}"

      Dir.chdir(temp_dir) do
        # Fetch the PR ref into a local branch pr-<number>
        # This grabs the PR's HEAD (contributor branch), not the auto-merge ref.
        system("git fetch origin pull/#{pr_number}/head:pr-#{pr_number}") or
          raise "Failed to fetch PR ##{pr_number} from origin"

        # Check out the PR branch
        system("git checkout pr-#{pr_number}") or
          raise "Failed to checkout PR branch pr-#{pr_number}"

        # Enable sparse-checkout
        system('git sparse-checkout init --cone') or
          raise 'Failed to init sparse-checkout'
        system("git sparse-checkout set #{folder_path}") or
          raise "Failed to set sparse-checkout path #{folder_path}"

        # Sync only new/updated files
        system("rsync -av --update --exclude='*.md' #{folder_path}/ #{local_dir}/")
      end
    end

    puts "Import complete! PR ##{pr_number} files copied to #{local_dir}."
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
