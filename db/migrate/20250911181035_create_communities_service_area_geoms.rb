class CreateCommunitiesServiceAreaGeoms < ActiveRecord::Migration[8.0]
  def change
    create_table :communities_service_area_geoms do |t|
      t.string :community_fips_code, null: false
      t.string :service_area_geom_aedg_id
      t.timestamps
    end

    add_foreign_key :communities_service_area_geoms, :communities, column: :community_fips_code, primary_key: :fips_code
    add_foreign_key :communities_service_area_geoms, :service_area_geoms, column: :service_area_geom_aedg_id, primary_key: :aedg_id
  end
end
