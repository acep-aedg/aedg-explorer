# rubocop:disable Rails/Output
module CommunityHelpers
  def self.run_check(url_helper, expected_codes = %w[200])
    helpers = Rails.application.routes.url_helpers
    host = ENV.fetch("HOST", "localhost:3000")

    label = url_helper.to_s.humanize
    failed = []

    puts "\n>>> Checking #{label} (Expecting #{expected_codes.join('/')})..."

    Community.find_each do |community|
      url_string = helpers.send(url_helper, community, host: host)

      url = URI.parse(url_string)
      response = Net::HTTP.get_response(url)

      unless expected_codes.include?(response.code)
        puts "  [!] #{community.name}: HTTP #{response.code}"
        failed << { name: community.name, code: response.code }
      end
    rescue StandardError => e
      puts "  [!] #{community.name} Error: #{e.message}"
      failed << { name: community.name, error: e.message }
    end

    puts "\n--- Finished #{label}: #{failed.count} issues found. ---"
  end
end
# rubocop:enable Rails/Output
