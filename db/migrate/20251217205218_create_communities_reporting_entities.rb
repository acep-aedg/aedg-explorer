class CreateCommunitiesReportingEntities < ActiveRecord::Migration[8.0]
  def change
    create_table :communities_reporting_entities do |t|
      t.string :community_fips_code, null: false
      t.references :reporting_entity, null: false, foreign_key: true
      t.timestamps
    end
    add_foreign_key :communities_reporting_entities, :communities, column: :community_fips_code, primary_key: :fips_code
  end
end
