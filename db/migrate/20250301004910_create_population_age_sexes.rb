class CreatePopulationAgeSexes < ActiveRecord::Migration[7.1]
  def change
    create_table :population_age_sexes do |t|
      t.string :community_fips_code, null: false
      t.integer :start_year
      t.integer :end_year
      t.boolean :is_most_recent
      t.string :geo_src
      t.integer :e_pop_age_total
      t.integer :m_pop_age_total
      t.integer :e_pop_age_under_5
      t.integer :m_pop_age_under_5
      t.integer :e_pop_age_5_9
      t.integer :m_pop_age_5_9
      t.integer :e_pop_age_10_14
      t.integer :m_pop_age_10_14
      t.integer :e_pop_age_15_19
      t.integer :m_pop_age_15_19
      t.integer :e_pop_age_20_24
      t.integer :m_pop_age_20_24
      t.integer :e_pop_age_25_34
      t.integer :m_pop_age_25_34
      t.integer :e_pop_age_35_44
      t.integer :m_pop_age_35_44
      t.integer :e_pop_age_45_54
      t.integer :m_pop_age_45_54
      t.integer :e_pop_age_55_59
      t.integer :m_pop_age_55_59
      t.integer :e_pop_age_60_64
      t.integer :m_pop_age_60_64
      t.integer :e_pop_age_65_74
      t.integer :m_pop_age_65_74
      t.integer :e_pop_age_75_84
      t.integer :m_pop_age_75_84
      t.integer :e_pop_age_85_plus
      t.integer :m_pop_age_85_plus
      t.integer :e_pop_age_median_age
      t.integer :m_pop_age_median_age
      t.integer :e_pop_age_under_18
      t.integer :m_pop_age_under_18
      t.integer :e_pop_age_18_plus
      t.integer :m_pop_age_18_plus
      t.integer :e_pop_age_21_plus
      t.integer :m_pop_age_21_plus
      t.integer :e_pop_age_62_plus
      t.integer :m_pop_age_62_plus
      t.integer :e_pop_age_65_plus
      t.integer :m_pop_age_65_plus
      t.integer :e_pop_total
      t.integer :m_pop_total
      t.integer :e_pop_male
      t.integer :m_pop_male
      t.integer :e_pop_female
      t.integer :m_pop_female

      t.timestamps
    end
    add_index :population_age_sexes, :community_fips_code
    add_index :population_age_sexes, :is_most_recent
    add_foreign_key :population_age_sexes, :communities, column: :community_fips_code, primary_key: :fips_code
  end
end
