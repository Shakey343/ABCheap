class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :fake_data
end
