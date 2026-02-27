require "test_helper"

class EmploymentAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @community = Community.new(fips_code: VALID_FIPS_CODE)
    @community.save(validate: false)

    @valid_props = {
      community_fips_code: VALID_FIPS_CODE,
      residents_employed: 500,
      unemployment_insurance_claimants: 100,
      measurement_year: 2021
    }
  end

  test "build_from_aedg builds an employment record in memory with valid props" do
    employment = Employment.build_from_aedg(@valid_props)

    assert_instance_of Employment, employment
    assert employment.new_record?
    assert employment.valid?, "Employment should be valid: #{employment.errors.full_messages}"

    assert_equal @community, employment.community
    assert_equal @valid_props[:residents_employed], employment.residents_employed
    assert_equal @valid_props[:unemployment_insurance_claimants], employment.unemployment_insurance_claimants
    assert_equal @valid_props[:measurement_year], employment.measurement_year
  end

  test "build_from_aedg results in an invalid record when community does not exist" do
    invalid_props = @valid_props.merge(community_fips_code: INVALID_FIPS_CODE)
    employment = Employment.build_from_aedg(invalid_props)

    assert_not employment.valid?
    assert_includes employment.errors[:community], "must exist"
  end

  test "build_from_aedg is invalid when community fips code is nil" do
    invalid_props = @valid_props.merge(community_fips_code: nil)
    employment = Employment.build_from_aedg(invalid_props)

    assert_not employment.valid?
    assert_includes employment.errors[:community], "must exist"
  end
end
