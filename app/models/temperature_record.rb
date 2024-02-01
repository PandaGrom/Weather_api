class TemperatureRecord < ApplicationRecord
  belongs_to :location

  validates :observation_time, presence: true
  validates :location, presence: true
  validates :value, presence: true
end
