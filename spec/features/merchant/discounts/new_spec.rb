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

  it "I can see a form with fields for minimum quantity and discount percentage" do
    visit "/merchant/discounts/new"

    fill_in "discount[min_quantity]", with: "10"
    fill_in "discount[percentage]", with: "20"
    click_button "Create Discount"

    discount = Discount.last
    expect(discount.min_quantity).to eql(10)
    expect(discount.percentage).to eql(20)
    expect(discount.merchant).to eql(@merchant_1)
  end

  it "If I incorrectly fill out form, I see an error message and redirect back to form." do
    visit "/merchant/discounts/new"

    fill_in "discount[min_quantity]", with: ""
    fill_in "discount[percentage]", with: "20"
    click_button "Create Discount"

    expect(page).to have_content('min_quantity: ["can\'t be blank"]')

    expect(page).to have_field("discount[min_quantity]")
    expect(page).to have_field("discount[percentage]")
  end

  it "If I correctly fill out form, I see a happy message and redirect back to index were I see new discount listed" do
    visit "/merchant/discounts/new"

    fill_in "discount[min_quantity]", with: "10"
    fill_in "discount[percentage]", with: "20"
    click_button "Create Discount"

    discount = Discount.last

    expect(current_path).to eql("/merchant/discounts")
    expect(page).to have_content("You have succefully created discount.")
    within("#discount-#{discount.id}") do
      expect(page).to have_content("#{discount.min_quantity}")
      expect(page).to have_content("#{discount.percentage}")
    end
  end
end
