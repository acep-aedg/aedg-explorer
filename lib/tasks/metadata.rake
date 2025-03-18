namespace :metadata do

  desc "Import metadata files"
  task import: :environment do
    filepath = Rails.root.join('db', 'imports', 'metadata')
    Metadatum.import_metadata(filepath)
  end
end
