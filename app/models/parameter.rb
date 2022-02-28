class Parameter < ApplicationRecord
  belongs_to :user_id
  has_many :options

  validates :origin, presence: true
  validates :destination, presence: true
end
