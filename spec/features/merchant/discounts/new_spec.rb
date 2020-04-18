require "rails_helper"

RSpec.describe "As a merchant visiting the new discount form" do
  before(:each) do

  end
  it "I can navigate to form from discounts index page" do
    visit "/merchant/discounts"

    click_link "Create Discount"

    expect(current_path).to eql("/merchant/discounts/new")
  end

  it "I can see a form with fields for min_quantity and percent_discount" do

  end
end
