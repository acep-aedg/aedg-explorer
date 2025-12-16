module Import
  module Versioning
    # Desired DataPond version tag for this release
    DATA_POND_TAG = 'v1.0.1'.freeze

    # Cleans a version string by removing leading "v"/"V" and whitespace.
    # Returns nil for nil or blank input.
    def self.normalize_version_string(raw_version)
      return nil if raw_version.blank?

      raw_version.sub(/\Av/i, '')
    end

    # Converts a version string into a Gem::Version object for comparison.
    # Returns nil if the string is nil or empty.
    # Aborts if the string isn't a valid semantic version.
    def self.to_gem_version(version_string)
      normalized = normalize_version_string(version_string)
      return nil if normalized.nil?

      Gem::Version.new(normalized)
    rescue ArgumentError
      abort("Invalid semantic version: #{version_string.inspect}")
    end
  end
end
