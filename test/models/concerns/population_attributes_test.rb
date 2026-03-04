require "test_helper"

class PopulationAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @community = Community.new(fips_code: VALID_FIPS_CODE)
    @community.save(validate: false)

    @valid_props = {
      community_fips_code: VALID_FIPS_CODE,
      total_population: 1000,
      year: 2020
    }
  end

  test "build_from_aedg builds a population record in memory with valid props" do
    population = Population.build_from_aedg(@valid_props)

    assert_instance_of Population, population
    assert population.new_record?
    assert population.valid?, "Should be valid: #{population.errors.full_messages}"

    assert_equal @community, population.community
    assert_equal @valid_props[:total_population], population.total_population
    assert_equal @valid_props[:year], population.year
  end

  test "is invalid for duplicate population for a community" do
    Population.build_from_aedg(@valid_props).save!
    duplicate = Population.build_from_aedg(@valid_props)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:community_fips_code], "has already been taken"
  end

  test "is invalid when community fips code does not match any existing community" do
    invalid_props = @valid_props.merge(community_fips_code: INVALID_FIPS_CODE)
    population = Population.build_from_aedg(invalid_props)

    assert_not population.valid?
    assert_includes population.errors[:community], "must exist"
  end
end
