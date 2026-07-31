require "net/http"
require "json"
require "uri"

module PlaneClient
  extend self

  IMPACT_TO_PRIORITY = {
    "critical" => "urgent",
    "serious" => "high",
    "moderate" => "medium",
    "minor" => "low"
  }.freeze

  def existing_tickets
    Rails.logger.debug "📋 Fetching Plane tickets..."
    http, request = build_request(method: :get)
    data = send_request(http, request)
    return [] unless data

    tickets = data["results"]

    tickets.map do |ticket|
      ticket["url"] ||= work_item_web_url(ticket["sequence_id"]) if ticket["sequence_id"]
      ticket
    end
  rescue StandardError => e
    Rails.logger.debug { "⚠️ Error fetching existing tickets: #{e.message}" }
    []
  end

  def create_work_item(name:, description_html: "", impact: nil, labels: [])
    payload = {
      name: name,
      description_html: description_html,
      priority: IMPACT_TO_PRIORITY[impact],
      labels: labels
    }.compact

    http, request = build_request(method: :post, payload: payload)
    response = send_request(http, request)

    return nil unless response.is_a?(Hash) && response["sequence_id"]

    {
      name: response["name"] || name,
      url: work_item_web_url(response["sequence_id"])
    }
  end

  def build_work_item_description(violation)
    urls = violation[:affected_urls] || []
    urls_list = urls.map { |url| "<li><code>#{CGI.escapeHTML(url)}</code></li>" }.join("\n")

    <<~HTML
      <p><strong>Rule:</strong> <a href="#{violation[:help_url]}" target="_blank">#{CGI.escapeHTML(violation[:rule_id].to_s)}</a></p>
      <p><strong>Description:</strong> #{CGI.escapeHTML(violation[:description].to_s)}</p>
      <p><strong>Help:</strong> #{CGI.escapeHTML(violation[:help].to_s)}</p>

      <hr />

      <h4>Target Element</h4>
      <p><strong>Selector:</strong> <code>#{CGI.escapeHTML(violation[:selector].to_s)}</code></p>
      <p><strong>HTML Snippet:</strong></p>
      <pre><code>#{CGI.escapeHTML(violation[:html].to_s)}</code></pre>

      <hr />

      <h4>Failure Summary</h4>
      <pre>#{CGI.escapeHTML(violation[:failure_summary].to_s)}</pre>

      <hr />

      <h4>Affected URLs (#{urls.size})</h4>
      <ul>
        #{urls_list.empty? ? '<li>None listed</li>' : urls_list}
      </ul>
    HTML
  end

  private

  def endpoint
    @endpoint ||= "#{base_url}/api/v1/workspaces/#{workspace_slug}/projects/#{project_id}/work-items/"
  end

  def base_url
    @base_url ||= ENV.fetch("PLANE_BASE_URL") { raise "Missing ENV['PLANE_BASE_URL']" }.chomp("/")
  end

  def workspace_slug
    @workspace_slug ||= ENV.fetch("PLANE_WORKSPACE_SLUG") { raise "Missing ENV['PLANE_WORKSPACE_SLUG']" }
  end

  def project_id
    @project_id ||= ENV.fetch("PLANE_PROJECT_ID") { raise "Missing ENV['PLANE_PROJECT_ID']" }
  end

  def project_id_string
    @project_id_string ||= ENV.fetch("PLANE_STRING_PROJECT_ID") { raise "Missing ENV['PLANE_STRING_PROJECT_ID']" }
  end

  def api_key
    @api_key ||= ENV.fetch("PLANE_API_KEY") { raise "Missing ENV['PLANE_API_KEY']" }
  end

  def work_item_web_url(sequence_id)
    "#{base_url}/#{workspace_slug}/browse/#{project_id_string}-#{sequence_id}"
  end

  def build_request(method:, payload: nil)
    uri = URI(endpoint)
    http = Net::HTTP.new(uri.host, uri.port)

    if uri.scheme == "https"
      http.use_ssl = true
      http.min_version = OpenSSL::SSL::TLS1_2_VERSION
    end

    request_class = method == :post ? Net::HTTP::Post : Net::HTTP::Get
    request = request_class.new(uri)

    request["X-API-Key"]    = api_key
    request["Content-Type"] = "application/json"
    request["User-Agent"]   = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AEDG-Explorer/1.0"
    request.body            = payload.to_json if payload

    [http, request]
  end

  def send_request(http, request)
    retries = 0
    max_retries = 3

    begin
      response = http.request(request)

      if response.code.to_i.between?(200, 299)
        JSON.parse(response.body)
      else
        body_text = response.body.to_s.dup.force_encoding("UTF-8")
        Rails.logger.debug { "❌ Failed (#{response.code}): #{body_text}" }
        nil
      end
    rescue Errno::ECONNRESET, Errno::ETIMEDOUT, OpenSSL::SSL::SSLError => e
      if retries < max_retries
        retries += 1
        wait_time = retries * 2
        Rails.logger.debug { "⚠️ Connection reset. Retrying in #{wait_time}s (#{retries}/#{max_retries})..." }
        sleep wait_time
        retry
      else
        Rails.logger.debug { "❌ Error after #{max_retries} retries: #{e.message}" }
        raise e
      end
    end
  end
end
