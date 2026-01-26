# lib/tasks/grids.rake
require "net/http"
require "uri"
namespace :grids do
  desc "Check grid show pages render without error"
  task test_show_view: :environment do
    include Rails.application.routes.url_helpers

    Rails.application.routes.default_url_options[:host] = "localhost:3000"

    failed = []

    puts "Checking grid show pages..."

    Grid.find_each do |grid|
      url = URI.parse(grid_url(grid))

      begin
        response = Net::HTTP.get_response(url)

        if response.code != "200"
          puts "Failed: #{grid.name}: HTTP #{response.code}, Message: #{response.message}"
          failed << { name: grid.name, code: response.code }
        end
      rescue StandardError => e
        puts "#{grid.name} (#{grid.fips_code}): #{e.message}"
        failed << { name: grid.name, error: e.message }
      end
    end

    puts "\n Summary:"
    if failed.empty?
      puts "All grid pages loaded successfully!"
    else
      puts "#{failed.count} grids failed to load:"
      failed.each do |entry|
        if entry[:error]
          puts "- #{entry[:name]}: #{entry[:error]}"
        else
          puts "- #{entry[:name]}: HTTP #{entry[:code]}"
        end
      end
    end
  end
end
