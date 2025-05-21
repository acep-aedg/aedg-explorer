require 'test_helper'

class EmploymentAttributesTest < ActiveSupport::TestCase
  VALID_FIPS_CODE = '000000'.freeze
  INVALID_FIPS_CODE = '999999'.freeze

  def setup
    @community = Community.new(fips_code: VALID_FIPS_CODE)
    @community.save(validate: false)

    @valid_props = {
      community_fips_code: VALID_FIPS_CODE,
      residents_employed: 500,
      unemployment_insurance_claimants: 100,
      measurement_year: 2021
    }
  end

  test 'import_aedg! creates an employment record with valid props' do
    employment = nil
    assert_difference -> { Employment.count }, +1 do
      employment = Employment.import_aedg!(@valid_props)
    end

    assert_equal @community, employment.community
    assert_equal @valid_props[:residents_employed], employment.residents_employed
    assert_equal @valid_props[:unemployment_insurance_claimants], employment.unemployment_insurance_claimants
    assert_equal @valid_props[:measurement_year], employment.measurement_year
  end

  test 'import_aedg! raises RecordInvalid for duplicate population for a community and year' do
    Employment.import_aedg!(@valid_props)
    assert_raises(ActiveRecord::RecordInvalid) do
      Employment.import_aedg!(@valid_props)
    end
  end

  test 'import_aedg! raises RecordInvalid when community fips code does not match an existing community' do
    invalid_props = @valid_props.merge(community_fips_code: INVALID_FIPS_CODE)
    assert_raises(ActiveRecord::RecordInvalid) do
      Employment.import_aedg!(invalid_props)
    end
  end

  test 'import_aedg! raises RecordInvalid when community fips code is nil' do
    invalid_props = @valid_props.merge(community_fips_code: nil)
    assert_raises(ActiveRecord::RecordInvalid) do
      Employment.import_aedg!(invalid_props)
    end
  end
end
