class AddIndexesToSpeedUpGeneration < ActiveRecord::Migration[8.0]
  def change
    add_index :communities_service_area_geoms, :community_fips_code, name: 'idx_csag_on_fips'
    add_index :communities_service_area_geoms, :service_area_geom_aedg_id, name: 'idx_csag_on_aedg_id'
    add_index :plants, :service_area_geom_aedg_id, name: 'idx_plants_on_sa_geom_aedg_id'
    add_index :yearly_generations, [:aea_plant_id, :year], name: 'idx_yearly_gen_on_aea_id_and_year'
    add_index :monthly_generations, [:aea_plant_id, :year, :month], name: 'idx_monthly_gen_composite'
  end
end
