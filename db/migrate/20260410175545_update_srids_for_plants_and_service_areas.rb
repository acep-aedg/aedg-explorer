class UpdateSridsForPlantsAndServiceAreas < ActiveRecord::Migration[8.0]
  def up
    change_column :plants, :location, :st_point, srid: 4326
    change_column :service_area_geoms, :boundary, :geometry, srid: 4326
    change_column :service_areas, :boundary, :geometry, srid: 4326

    remove_index :plants, :location if index_exists?(:plants, :location)
    add_index :plants, :location, using: :gist

    remove_index :service_area_geoms, :boundary if index_exists?(:service_area_geoms, :boundary)
    add_index :service_area_geoms, :boundary, using: :gist

    remove_index :service_areas, :boundary if index_exists?(:service_areas, :boundary)
    add_index :service_areas, :boundary, using: :gist
  end

  def down
    remove_index :plants, :location if index_exists?(:plants, :location)
    remove_index :service_area_geoms, :boundary if index_exists?(:service_area_geoms, :boundary)
    remove_index :service_areas, :boundary if index_exists?(:service_areas, :boundary)

    change_column :plants, :location, :geometry, srid: 0
    change_column :service_area_geoms, :boundary, :geometry, srid: 0
    change_column :service_areas, :boundary, :geometry, srid: 0
  end
end
