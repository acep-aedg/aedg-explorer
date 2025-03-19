class ReplaceSenateDistrictWithForeignKeyInCld < ActiveRecord::Migration[7.1]
  def change
    remove_column :communities_legislative_districts, :senate_district

    add_reference :communities_legislative_districts, :senate_district, foreign_key: true, null: false
  end
end
