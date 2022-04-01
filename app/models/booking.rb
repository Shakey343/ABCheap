class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :result
  monetize :amount_cents
end
