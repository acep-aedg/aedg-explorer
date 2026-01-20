require 'test_helper'
require 'rgeo'

class CommunityAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @geom_factory = RGeo::Geographic.simple_mercator_factory
    @point_geom = @geom_factory.point(0.5, 0.5)

    @regional_corporation = regional_corporations(:one)
    @borough = boroughs(:one)

    @grid = Grid.create!(aedg_id: VALID_AEDG_ID, name: 'Test Grid')

    @valid_props = {
      fips_code: VALID_FIPS_CODE,
      name: 'Test Community',
      regional_corporation_fips_code: @regional_corporation.fips_code,
      borough_fips_code: @borough.fips_code,
      grid_id: VALID_AEDG_ID
    }
  end

  test 'import_aedg_with_geom! creates community with valid props and geometry' do
    community = nil
    assert_difference -> { Community.count }, +1 do
      community = Community.import_aedg_with_geom!(@valid_props, @point_geom)
    end

    assert_equal @valid_props[:fips_code], community.fips_code
    assert_equal @valid_props[:name], community.name
    assert_equal @regional_corporation, community.regional_corporation
    assert_equal @borough, community.borough
    assert_equal @point_geom.as_text, community.location.as_text
  end

  test 'import_aedg_with_geom! raises RecordInvalid with missing fips code' do
    invalid_props = @valid_props.merge(fips_code: nil)
    assert_raises(ActiveRecord::RecordInvalid) do
      Community.import_aedg_with_geom!(invalid_props, @point_geom)
    end
  end

  test 'import_aedg_with_geom! raises ArgumentError with missing geometry' do
    assert_raises(ArgumentError) do
      Community.import_aedg_with_geom!(@valid_props)
    end
  end
end
