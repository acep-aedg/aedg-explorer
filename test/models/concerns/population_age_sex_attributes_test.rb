require 'test_helper'

class PopulationAgeSexAttributesTest < ActiveSupport::TestCase
  VALID_FIPS_CODE = '000000'.freeze
  INVALID_FIPS_CODE = '999999'.freeze

  def setup
    @community = Community.new(fips_code: VALID_FIPS_CODE)
    @community.save(validate: false)

    @valid_props = {
      community_fips_code: VALID_FIPS_CODE,
      is_most_recent: true
    }
  end

  test 'import_aedg! creates a population age sex record with valid props' do
    pas = nil
    assert_difference -> { PopulationAgeSex.count }, +1 do
      pas = PopulationAgeSex.import_aedg!(@valid_props)
    end

    assert_equal @community, pas.community
    assert_equal @valid_props[:community_fips_code], pas.community_fips_code
    assert_equal @valid_props[:is_most_recent], pas.is_most_recent
  end

  test 'import_aedg! does not create duplicate population age sex for the same community and is most recent' do
    PopulationAgeSex.import_aedg!(@valid_props)
    assert_raises(ActiveRecord::RecordInvalid) do
      PopulationAgeSex.import_aedg!(@valid_props)
    end
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
