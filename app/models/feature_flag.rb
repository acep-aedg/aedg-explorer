class FeatureFlag < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def self.enabled?(name)
    find_by(name: name)&.enabled || false
  end

  def self.set(name, state)
    flag = find_or_initialize_by(name: name)
    flag.enabled = ActiveModel::Type::Boolean.new.cast(state)
    flag.save!
  end

  def self.list
    all.pluck(:name, :enabled).to_h
  end
end
