require "rails_helper"

RSpec.describe "As a merchant visiting the new discount form" do
  before(:each) do
    @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end

  it "I can navigate to form from discounts index page" do
    visit "/merchant/discounts"

    click_link "New Discount"

    expect(current_path).to eql("/merchant/discounts/new")
  end

  it "I can see a form with fields for min_quantity and percent_discount" do

  end
end
