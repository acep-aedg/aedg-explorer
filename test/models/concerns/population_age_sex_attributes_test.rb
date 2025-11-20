require 'test_helper'

class PopulationAgeSexAttributesTest < ActiveSupport::TestCase
  include TestConstants

  def setup
    @community = communities(:one)
    @valid_props = {
      community_fips_code: @community.fips_code
    }
  end

  test 'import_aedg! creates a population age sex record with valid props' do
    pas = nil
    assert_difference -> { PopulationAgeSex.count }, +1 do
      pas = PopulationAgeSex.import_aedg!(@valid_props)
    end

    assert_equal @community, pas.community
    assert_equal @valid_props[:community_fips_code], pas.community_fips_code
  end

  test 'import_aedg! raises RecordInvalid when community fips code does not match an existing community' do
    invalid_props = @valid_props.merge(community_fips_code: INVALID_FIPS_CODE)
    assert_raises(ActiveRecord::RecordInvalid) do
      PopulationAgeSex.import_aedg!(invalid_props)
    end
  end

  test 'import_aedg! raises RecordInvalid when community fips code is nil' do
    invalid_props = @valid_props.merge(community_fips_code: nil)
    assert_raises(ActiveRecord::RecordInvalid) do
      PopulationAgeSex.import_aedg!(invalid_props)
    end
  end
end
