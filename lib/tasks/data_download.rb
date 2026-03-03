module DataDownload
  class << self
    def download(remote_path, local_path)
      repo_url = ENV.fetch("GH_DATA_REPO_URL", "https://github.com/acep-aedg/aedg-data-pond")

      # --- 1. Determine Source ---
      ref_info = determine_git_ref(repo_url)

      # --- 2. Setup Local Directory ---
      FileUtils.mkdir_p(local_path)
      FileUtils.touch(File.join(local_path, ".keep"))

      # --- 3. Execute Git Operations ---
      Dir.mktmpdir do |temp_dir|
        puts "⬇️  Cloning repository..."
        system("git clone --no-checkout #{repo_url} #{temp_dir}") or raise "Failed to clone"

        Dir.chdir(temp_dir) do
          puts "🔄 Fetching and Checking out #{ref_info[:name]}..."
          system(ref_info[:fetch_cmd]) or raise "Fetch failed"
          system(ref_info[:checkout_cmd]) or raise "Checkout failed"

          puts "📂 Syncing #{remote_path} to #{local_path}..."
          system("git sparse-checkout init --cone")
          system("git sparse-checkout set #{remote_path}")
          system("rsync -av --delete --exclude='metadata' --exclude='.keep' #{remote_path}/ #{local_path}/")
        end
      end
      puts "✅ Download complete! Source: #{ref_info[:name]}"
    end

    private

    def determine_git_ref(repo_url)
      if ENV["PR"].present?
        {
          name: "PR ##{ENV['PR']}",
          fetch_cmd: "git fetch origin pull/#{ENV['PR']}/head:pr-#{ENV['PR']}",
          checkout_cmd: "git checkout pr-#{ENV['PR']}"
        }
      elsif ENV["BRANCH"].present?
        {
          name: "Branch '#{ENV['BRANCH']}'",
          fetch_cmd: "git fetch origin #{ENV['BRANCH']}",
          checkout_cmd: "git checkout -B #{ENV['BRANCH']} origin/#{ENV['BRANCH']}"
        }
      else
        tag = Import::Versioning::DATA_POND_TAG
        {
          name: "Tag #{tag}",
          fetch_cmd: "git fetch --tags",
          checkout_cmd: "git checkout tags/#{tag} -b temp-tag-branch"
        }
      end
    end
  end
end
