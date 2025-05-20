require 'test_helper'
require 'rgeo'

class CommunityAttributesTest < ActiveSupport::TestCase
  def setup
    @geom_factory = RGeo::Geographic.simple_mercator_factory
    @point_geom = @geom_factory.point(0.5, 0.5)

    @regional_corporation = regional_corporations(:one)
    @borough = boroughs(:one)

    @grid = Grid.create!(aedg_id: 123, name: 'Stubbed Grid')
    Grid.stubs(:from_aedg_id).with(123).returns([@grid])

    @reporting_entity = ReportingEntity.create!(aedg_id: 456, name: 'Stubbed RE', year: 2021, grid: @grid)
    ReportingEntity.stubs(:from_aedg_id).with(456).returns([@reporting_entity])

    @valid_props = {
      fips_code: '123456',
      name: 'Test Community',
      gnis_code: '1234567',
      regional_corporation_fips_code: @regional_corporation.fips_code,
      borough_fips_code: @borough.fips_code,
      grid_id: 123,
      reporting_entity_id: 456,
      puma_code: '123456',
      dcra_code: '0f73f1c4-9024-4d2b-92c4-75ea71a0596e',
      latitude: 0.5,
      longitude: 0.5,
      economic_region: 'Test Economic Region',
      pce_eligible: true,
      pce_active: true,
      subsistence: true
    }
  end

  test 'creates a new community with geometry and attributes' do
    community = nil

    assert_difference -> { Community.count }, +1 do
      community = Community.import_aedg_with_geom!(@valid_props, @point_geom)
    end

    assert_equal @valid_props[:fips_code], community.fips_code
    assert_equal @valid_props[:name], community.name
    assert_equal @valid_props[:gnis_code], community.gnis_code
    assert_equal @regional_corporation, community.regional_corporation
    assert_equal @borough, community.borough
    assert_equal @valid_props[:puma_code], community.puma_code
    assert_equal @valid_props[:dcra_code], community.dcra_code
    assert_equal @valid_props[:latitude], community.latitude
    assert_equal @valid_props[:longitude], community.longitude
    assert_equal @valid_props[:economic_region], community.economic_region
    assert_equal @valid_props[:pce_eligible], community.pce_eligible
    assert_equal @valid_props[:pce_active], community.pce_active
    assert_equal @valid_props[:subsistence], community.subsistence
    assert_equal @point_geom.as_text, community.location.as_text
    assert_equal @reporting_entity, community.reporting_entity
    assert_equal @grid, community.reporting_entity.grid
  end

  test 'fails to creates a new community without fips code' do
    invalid_props = @valid_props.merge(fips_code: nil)
    assert_raises(ActiveRecord::RecordInvalid) do
      Community.import_aedg_with_geom!(invalid_props, @point_geom)
    end
  end
end
