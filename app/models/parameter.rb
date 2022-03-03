class Parameter < ApplicationRecord
  belongs_to :user, optional: true
  validates :origin, presence: true
  validates :destination, presence: true
  validates :preferred_start, presence: true

  geocoded_by :origin
  after_validation :geocode, if: :will_save_change_to_origin?

  geocoded_by :destination
  after_validation :geocode, if: :will_save_change_to_destination?
end
