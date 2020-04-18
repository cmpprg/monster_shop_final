require "rails_helper"

RSpec.describe Discount, type: :model do
  describe "Validations" do
    it {should validate_presence_of :min_quantity}
    it {should validate_presence_of :percentage}
  end

  describe "Relationships" do
    it {should belong_to :merchant}
  end

end
