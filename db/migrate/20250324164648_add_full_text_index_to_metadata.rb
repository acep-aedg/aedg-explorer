class AddFullTextIndexToMetadata < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      ALTER TABLE metadata
      ADD COLUMN tsvector_data tsvector GENERATED ALWAYS AS (
        jsonb_to_tsvector('english', data, '["string", "numeric"]')
      ) stored;
    SQL
  end

  def down
    remove_column :metadata, :tsvector_data
  end
end
