class Location < ApplicationRecord
  has_many :temperature_records, dependent: :destroy

  validates :uuid, uniqueness: true
  validates :location_name, presence: true
end
