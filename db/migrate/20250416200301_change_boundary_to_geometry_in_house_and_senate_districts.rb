class ChangeBoundaryToGeometryInHouseAndSenateDistricts < ActiveRecord::Migration[7.1]
  def up
    # HOUSE
    add_column :house_districts, :boundary_geometry, :geometry, srid: 4326
    execute <<-SQL
      UPDATE house_districts SET boundary_geometry = ST_GeomFromEWKT(ST_AsEWKT(boundary));
    SQL
    remove_column :house_districts, :boundary
    rename_column :house_districts, :boundary_geometry, :boundary
    add_index :house_districts, :boundary, using: :gist, name: "index_house_districts_on_boundary"

    # SENATE
    add_column :senate_districts, :boundary_geometry, :geometry, srid: 4326
    execute <<-SQL
      UPDATE senate_districts SET boundary_geometry = ST_GeomFromEWKT(ST_AsEWKT(boundary));
    SQL
    remove_column :senate_districts, :boundary
    rename_column :senate_districts, :boundary_geometry, :boundary
    add_index :senate_districts, :boundary, using: :gist, name: "index_senate_districts_on_boundary"
  end

  def down
    # HOUSE
    rename_column :house_districts, :boundary, :boundary_geometry
    add_column :house_districts, :boundary, :geometry, geographic: true, srid: 4326
    execute <<-SQL
      UPDATE house_districts SET boundary = ST_GeomFromEWKT(ST_AsEWKT(boundary_geometry));
    SQL
    remove_column :house_districts, :boundary_geometry
    add_index :house_districts, :boundary, using: :gist, name: "index_house_districts_on_boundary"

    # SENATE
    rename_column :senate_districts, :boundary, :boundary_geometry
    add_column :senate_districts, :boundary, :geometry, geographic: true, srid: 4326
    execute <<-SQL
      UPDATE senate_districts SET boundary = ST_GeomFromEWKT(ST_AsEWKT(boundary_geometry));
    SQL
    remove_column :senate_districts, :boundary_geometry
    add_index :senate_districts, :boundary, using: :gist, name: "index_senate_districts_on_boundary"
  end
end
