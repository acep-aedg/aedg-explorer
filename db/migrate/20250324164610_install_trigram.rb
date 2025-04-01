class InstallTrigram < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'pg_trgm'
    enable_extension 'fuzzystrmatch'
  end
end
