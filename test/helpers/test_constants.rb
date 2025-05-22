# test/helpers/test_constants.rb

# These constants are used across tests to provide unique, non-conflicting identifiers.
# - AEDG IDs can be any arbitrary integers.
# - FIPS codes should NOT match any existing FIPS codes in fixtures to avoid collisions when testing creation.

module TestConstants
  VALID_AEDG_ID = 1111
  INVALID_AEDG_ID = 9999
  VALID_FIPS_CODE = '0000'.freeze
  INVALID_FIPS_CODE = '9999'.freeze
end
