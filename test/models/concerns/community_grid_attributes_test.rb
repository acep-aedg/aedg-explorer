require "test_helper"

class CommunityGridAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @grid = Grid.create!(aedg_id: VALID_AEDG_ID, name: "Test Grid")
    @community = communities(:one)
    @valid_props = {
      community_fips_code: @community.fips_code,
      grid_id: VALID_AEDG_ID,
      connection_year: 2010,
      termination_year: 9999
    }
  end

  test "build_from_aedg builds a community grid in memory with valid props" do
    cg = CommunityGrid.build_from_aedg(@valid_props)
    assert_instance_of CommunityGrid, cg
    assert cg.new_record?
    assert cg.valid?, "CommunityGrid should be valid: #{cg.errors.full_messages}"

    assert_equal @community, cg.community
    assert_equal @grid, cg.grid
    assert_equal @valid_props[:connection_year], cg.connection_year
    assert_equal @valid_props[:termination_year], cg.termination_year
  end

  test "build_from_aedg is invalid when community fips code does not exist" do
    invalid_props = @valid_props.merge(community_fips_code: INVALID_FIPS_CODE)
    cg = CommunityGrid.build_from_aedg(invalid_props)

    assert_not cg.valid?
    assert_includes cg.errors[:community], "must exist"
  end

  test "build_from_aedg is invalid when grid does not exist" do
    invalid_props = @valid_props.merge(grid_id: INVALID_AEDG_ID)
    cg = CommunityGrid.build_from_aedg(invalid_props)

    assert_not cg.valid?
    assert_includes cg.errors[:grid], "must exist"
  end

  test "build_from_aedg is invalid when fips code is nil" do
    invalid_props = @valid_props.merge(community_fips_code: nil)
    cg = CommunityGrid.build_from_aedg(invalid_props)

    assert_not cg.valid?
    assert_includes cg.errors[:community_fips_code], "can't be blank"
  end
end
