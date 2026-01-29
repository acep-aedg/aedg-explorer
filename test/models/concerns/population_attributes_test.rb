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

  test "import_aedg! creates a population record with valid props" do
    population = nil
    assert_difference -> { Population.count }, +1 do
      population = Population.import_aedg!(@valid_props)
    end
    assert_equal @community, population.community
    assert_equal @valid_props[:total_population], population.total_population
    assert_equal @valid_props[:year], population.year
  end

  test "import_aedg! raises RecordInvalid for duplicate population for a community" do
    Population.import_aedg!(@valid_props)

    assert_raises(ActiveRecord::RecordInvalid) do
      Population.import_aedg!(@valid_props)
    end
  end

  test "import_aedg! raises RecordInvalid when community fips code does not match any existing community" do
    invalid_props = @valid_props.merge(community_fips_code: INVALID_FIPS_CODE)
    assert_raises(ActiveRecord::RecordInvalid) do
      Population.import_aedg!(invalid_props)
    end
  end

  test "import_aedg! raises RecordInvalid when community fips code is nil" do
    invalid_props = @valid_props.merge(community_fips_code: nil)
    assert_raises(ActiveRecord::RecordInvalid) do
      Population.import_aedg!(invalid_props)
    end
  end
end
