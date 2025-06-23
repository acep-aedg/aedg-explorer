# lib/tasks/check_community_show.rake
require 'net/http'
require 'uri'
namespace :communities do
  desc 'Check community show pages render without error'
  task test_show_view: :environment do
    include Rails.application.routes.url_helpers
    Rails.application.routes.default_url_options[:host] = 'localhost:3000'

    failed = []

    puts 'Checking community show pages...'

    Community.find_each do |community|
      url = URI.parse(community_url(community))

      begin
        response = Net::HTTP.get_response(url)

        if response.code != '200'
          puts "Failed: #{community.name} (#{community.fips_code}): HTTP #{response.code}, Message: #{response.message}"
          failed << { name: community.name, fips: community.fips_code, code: response.code }
        end
      rescue StandardError => e
        puts "#{community.name} (#{community.fips_code}): #{e.message}"
        failed << { name: community.name, fips: community.fips_code, error: e.message }
      end
    end

    puts "\n Summary:"
    if failed.empty?
      puts 'All community pages loaded successfully!'
    else
      puts "#{failed.count} communities failed to load:"
      failed.each do |entry|
        if entry[:error]
          puts "- #{entry[:name]} (#{entry[:fips]}): #{entry[:error]}"
        else
          puts "- #{entry[:name]} (#{entry[:fips]}): HTTP #{entry[:code]}"
        end
      end
    end
  end
end
