json.extract! community, :id, :fips_code, :name, :latitude, :longitude, :ansi_code, :community_id, :global_id,
              :created_at, :updated_at
json.url community_url(community, format: :json)
