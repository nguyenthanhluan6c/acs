class Level < ApplicationRecord
  has_many :allowance_details
  belongs_to :allowance
end
