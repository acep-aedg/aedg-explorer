require 'test_helper'

class PopulationAttributesTest < ActiveSupport::TestCase
  VALID_FIPS_CODE = '000000'.freeze
  INVALID_FIPS_CODE = '999999'.freeze

  def setup
    @community = Community.new(fips_code: VALID_FIPS_CODE)
    @community.save(validate: false)

    @valid_props = {
      community_fips_code: @community.fips_code,
      total_population: 1000,
      year: 2020
    }
  end

  test 'creates a new population record' do
    population = nil
    assert_difference -> { Population.count }, +1 do
      population = Population.import_aedg!(@valid_props)
    end

    assert_equal @community, population.community
    assert_equal @valid_props[:total_population], population.total_population
    assert_equal @valid_props[:year], population.year
  end

  test 'raises error for duplicate population for the same community' do
    Population.import_aedg!(@valid_props)

    assert_raises(ActiveRecord::RecordInvalid) do
      Population.import_aedg!(@valid_props)
    end
  end

  test 'raises error if community fips code does not match any community' do
    props_with_invalid_fips = @valid_props.merge(community_fips_code: INVALID_FIPS_CODE)
    assert_raises(ActiveRecord::RecordInvalid) do
      Population.import_aedg!(props_with_invalid_fips)
    end
  end
end
