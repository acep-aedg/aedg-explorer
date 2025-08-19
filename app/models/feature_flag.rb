class FeatureFlag < ApplicationRecord
  STATES = %w[enabled disabled].freeze

  validates :name, presence: true, uniqueness: true
  validates :state, inclusion: { in: STATES }

  def self.enable!(name)
    find_or_initialize_by(name: name).update!(state: 'enabled')
  end

  def self.disable!(name)
    find_or_initialize_by(name: name).update!(state: 'disabled')
  end

  def self.enabled?(name)
    find_by(name: name)&.state == 'enabled'
  end

  def self.list
    all.pluck(:name, :state).to_h
  end
end
