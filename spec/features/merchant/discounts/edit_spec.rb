require "rails_helper"

RSpec.describe "As a merchant when i visit the edit discount form" do
  before(:each) do
    @merchant1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @merchant_user = @merchant1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
    @discount1 = @merchant1.discounts.create!(min_quantity: 10, percentage: 20)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
  end

  it "I can fill out the form, click Update Discount and be taken back to index where i see changes." do
    visit "/merchant/discounts/#{@discount1.id}/edit"

    expect(@discount1.min_quantity).to eql(10)
    expect(@discount1.percentage).to eql(20)

    fill_in "discount[min_quantity]", with: "15"
    fill_in "discount[percentage]", with: "25"
    click_button "Update Discount"

    expect(current_path).to eql("/merchant/discounts")

    @discount1.reload
    within("#discount-#{@discount1.id}") do
      expect(page).to have_content("15")
      expect(page).to have_content("25")
    end
    expect(page).to have_content("You have succefully updated discount.")
  end

  it "If I incorrectly fill out form, I get a sad message and am taken back to form page." do
    visit "/merchant/discounts/#{@discount1.id}/edit"

    fill_in "discount[min_quantity]", with: ""
    fill_in "discount[percentage]", with: "50"
    click_button "Update Discount"

    expect(page).to have_content("Min quantity can't be blank")

    expect(page).to have_field("discount[min_quantity]")
    expect(page).to have_field("discount[percentage]")
  end
end
