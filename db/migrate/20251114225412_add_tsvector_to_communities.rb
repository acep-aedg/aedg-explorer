class AddTsvectorToCommunities < ActiveRecord::Migration[8.0]
  def change
    add_column :communities, :tsvector_data, :virtual,
      type: :tsvector,
      as: "to_tsvector('english', coalesce(name::text, ''))",
      stored: true
  end

end
