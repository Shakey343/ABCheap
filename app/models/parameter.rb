class Parameter < ApplicationRecord
  belongs_to :user
  has_many :options
end
