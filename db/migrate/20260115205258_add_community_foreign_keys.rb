class AddCommunityForeignKeys < ActiveRecord::Migration[8.0]
  def up
    add_index :employments, :community_fips_code
    add_foreign_key :employments, :communities,
                    column: :community_fips_code,
                    primary_key: :fips_code,
                    on_delete: :cascade

    add_index :income_poverties, :community_fips_code
    add_foreign_key :income_poverties, :communities,
                    column: :community_fips_code,
                    primary_key: :fips_code,
                    on_delete: :cascade

    add_index :household_incomes, :community_fips_code
    add_foreign_key :household_incomes, :communities,
                    column: :community_fips_code,
                    primary_key: :fips_code,
                    on_delete: :cascade
  end

  def down
    remove_foreign_key :employments, :communities, column: :community_fips_code
    remove_index :employments, :community_fips_code

    remove_foreign_key :income_poverties, :communities, column: :community_fips_code
    remove_index :income_poverties, :community_fips_code

    remove_foreign_key :household_incomes, :communities, column: :community_fips_code
    remove_index :household_incomes, :community_fips_code
  end
end
