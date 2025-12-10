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

  desc 'Download data files (Defaults to Tag, or pass PR=123 to test a PR)'
  task download_data: [:environment] do
    repo_url = ENV.fetch('GH_METADATA_REPO_URL', 'https://github.com/acep-aedg/aedg-data-pond')
    folder_path = 'data/public'
    local_dir = Rails.root.join('db/imports/metadata').to_s

    # Ensure local dir exists
    FileUtils.mkdir_p(local_dir)

    # Determine Source (Tag vs PR)
    if ENV['PR'].present?
      pr_number = ENV['PR']
      puts "PR detected! Preparing to fetch Pull Request ##{pr_number}..."

      # Git commands for PR
      fetch_cmd    = "git fetch origin pull/#{pr_number}/head:pr-#{pr_number}"
      checkout_cmd = "git checkout pr-#{pr_number}"
      source_name  = "PR ##{pr_number}"
    else
      tag = Import::Versioning::DATA_POND_TAG
      # Check if tag exists remotely before starting expensive clone
      tag_exists = system("git ls-remote --tags #{repo_url} refs/tags/#{tag} | grep #{tag}")
      raise "ERROR: Tag '#{tag}' not found in repo #{repo_url}" unless tag_exists

      # Git commands for Tag
      fetch_cmd    = 'git fetch --tags'
      checkout_cmd = "git checkout tags/#{tag} -b temp-tag-branch"
      source_name  = "Tag #{tag}"
    end

    # Create local directory for import
    FileUtils.mkdir_p(local_dir)
    keep_file = File.join(local_dir, '.keep')
    FileUtils.touch(keep_file) unless File.exist?(keep_file)

    # Pull data from remote repository
    Dir.mktmpdir do |temp_dir|
      system("git clone --no-checkout #{repo_url} #{temp_dir}") or raise "Failed to clone #{repo_url}"

      Dir.chdir(temp_dir) do
        system(fetch_cmd) or raise "Failed to fetch #{source_name}"
        puts "Checking out #{source_name}..."
        system(checkout_cmd) or raise "Failed to checkout #{source_name}"

        # Enable sparse-checkout
        system('git sparse-checkout init --cone') or raise 'Failed to init sparse-checkout'
        system("git sparse-checkout set #{folder_path}") or raise "Failed to set sparse-checkout path #{folder_path}"

        # Sync files
        puts "📂 Syncing files to #{local_dir}..."
        system("rsync -av --update #{folder_path}/ #{local_dir}/")
      end
    end

    puts "Download complete! #{source_name} files copied to #{local_dir}."
  end

  desc 'Clear metadata records'
  task clear: [:environment] do
    puts 'Clearing metadata table...'
    Metadatum.destroy_all
  end
end
