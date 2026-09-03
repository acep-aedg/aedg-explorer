# rubocop:disable Rails/Output
module ViewChecker
  def self.run_check(collection, url_helper, expected_codes = %w[200])
    helpers = Rails.application.routes.url_helpers
    host = ENV.fetch("HOST", "localhost:3000")

    label = url_helper.to_s.gsub(/_url$/, "").titleize
    failed = []

    puts "\n>>> Checking #{label}..."

    collection.find_each do |record|
      url_string = helpers.send(url_helper, record, host: host)
      url = URI.parse(url_string)
      response = Net::HTTP.get_response(url)

      unless expected_codes.include?(response.code)
        puts "  [!] #{record.name}: HTTP #{response.code}"
        failed << { name: record.name, code: response.code }
      end
    rescue StandardError => e
      puts "  [!] #{record.name} Error: #{e.message}"
      failed << { name: record.name, error: e.message }
    end

    puts "\n--- Finished #{label}: #{failed.count} issues found. ---"
  end
end
# rubocop:enable Rails/Output
