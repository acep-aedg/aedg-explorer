namespace :storage do
  desc "Deletes all ActiveStorage files from the disk"
  task clear: :environment do
    storage_path = Rails.root.join("storage")

    if Dir.exist?(storage_path)
      FileUtils.rm_rf(Dir.glob("#{storage_path}/*"))
      puts "🧹 Cleared storage directory: #{storage_path}"
    else
      puts "ℹ️ Storage directory not found, nothing to clear."
    end
  end
end
