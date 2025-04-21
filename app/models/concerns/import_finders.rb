# app/models/concerns/import_finders.rb
module ImportFinders
  extend ActiveSupport::Concern

  included do
    has_one :aedg_import, as: :importable
    after_create :create_importable

    scope :from_aedg_id, lambda { |id|
      joins(:aedg_import).where(aedg_import: { aedg_id: id })
    }

    def create_importable
      raise 'aedg_id is required' if aedg_id.nil?

      AedgImport.create!(aedg_id: aedg_id, importable: self)
    end

    def aedg_id=(id)
      @aedg_id = id
    end

    def aedg_id
      @aedg_id
    end
  end
end
