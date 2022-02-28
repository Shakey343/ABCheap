class Parameter < ApplicationRecord
  belongs_to :user_id

  validates :origin, presence: true
  validates :destination, presence: true
  validates :earliest_start, :latest_finish, presence: true
end
