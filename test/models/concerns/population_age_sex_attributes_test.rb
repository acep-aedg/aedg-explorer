require "test_helper"

class PopulationAgeSexAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @community = communities(:one)
    @valid_props = {
      community_fips_code: @community.fips_code
    }
  end

  test "build_from_aedg builds a population age sex record in memory with valid props" do
    pas = PopulationAgeSex.build_from_aedg(@valid_props)

    assert_instance_of PopulationAgeSex, pas
    assert pas.new_record?
    assert pas.valid?, "Should be valid: #{pas.errors.full_messages}"

    assert_equal @community, pas.community
    assert_equal @valid_props[:community_fips_code], pas.community_fips_code
  end

  test "is invalid when community fips code does not match an existing community" do
    invalid_props = @valid_props.merge(community_fips_code: INVALID_FIPS_CODE)
    pas = PopulationAgeSex.build_from_aedg(invalid_props)

    assert_not pas.valid?
    assert_includes pas.errors[:community], "must exist"
  end
end
