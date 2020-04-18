class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :min_quantity
  validates_presence_of :percentage
end
