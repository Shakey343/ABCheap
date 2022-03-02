class Parameter < ApplicationRecord
  belongs_to :user, optional: true
end
