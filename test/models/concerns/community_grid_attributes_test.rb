require 'test_helper'

class CommunityGridAttributesTest < ActiveSupport::TestCase
  VALID_AEGD_ID = 1111
  INVALID_AEGD_ID = 9999
  INVALID_FIPS_CODE = '9999'.freeze

  def setup
    @grid = Grid.create!(aedg_id: VALID_AEGD_ID, name: 'Test Grid')
    @community = communities(:one)
    @valid_props = {
      community_fips_code: @community.fips_code,
      grid_id: VALID_AEGD_ID,
      connection_year: 2010,
      termination_year: 9999
    }
  end

  test 'import_aedg! creates a community grid with valid props' do
    Grid.stubs(:from_aedg_id).with(VALID_AEGD_ID).returns([@grid])
    cg = nil
    assert_difference -> { CommunityGrid.count }, 1 do
      cg = CommunityGrid.import_aedg!(@valid_props)
    end
    assert_equal @community, cg.community
    assert_equal @valid_props[:connection_year], cg.connection_year
    assert_equal @valid_props[:termination_year], cg.termination_year
  end

  test 'import_aedg! raises RecordInvalid when community fips code is nil' do
    invalid_props = @valid_props.merge(community_fips_code: nil)
    assert_no_difference -> { CommunityGrid.count } do
      assert_raises(ActiveRecord::RecordInvalid) do
        CommunityGrid.import_aedg!(invalid_props)
      end
    end
  end

  test 'import_aedg! raises RecordInvalid when community fips code does not match an existing community' do
    invalid_props = @valid_props.merge(community_fips_code: INVALID_FIPS_CODE)
    assert_no_difference -> { CommunityGrid.count } do
      assert_raises(ActiveRecord::RecordInvalid) do
        CommunityGrid.import_aedg!(invalid_props)
      end
    end
  end
end
