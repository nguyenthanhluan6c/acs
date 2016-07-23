class Employee < ApplicationRecord
  belongs_to :category

  delegate :name, to: :category, prefix: true
end
