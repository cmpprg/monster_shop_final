require "rails_helper"

RSpec.describe "As a merchant when i visit the discounts index page" do
  before(:each)do
  @merchant1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
  @merchant2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
  @merchant_user = @merchant1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
  @discount1 = @merchant1.discounts.create!(min_quantity: 10, percentage: 20)
  @discount2 = @merchant1.discounts.create!(min_quantity: 20, percentage: 40)
  @discount3 = @merchant1.discounts.create!(min_quantity: 30, percentage: 60)
  @discount4 = @merchant2.discounts.create!(min_quantity: 40, percentage: 30)
  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
  end
  it "I see a list of my existing discounts" do
    visit "/merchant/discounts"

    within("#discount-#{@discount1.id}") do
      expect(page).to have_content("Minimum Quantity to get Discount = #{@discount1.min_quantity}")
      expect(page).to have_content("Discount Percentage = #{@discount1.percentage}")
    end
    within("#discount-#{@discount2.id}") do
      expect(page).to have_content("Minimum Quantity to get Discount = #{@discount2.min_quantity}")
      expect(page).to have_content("Discount Percentage = #{@discount2.percentage}")
    end
    within("#discount-#{@discount3.id}") do
      expect(page).to have_content("Minimum Quantity to get Discount = #{@discount3.min_quantity}")
      expect(page).to have_content("Discount Percentage = #{@discount3.percentage}")
    end

    expect(page).to have_no_css("#discount-#{@discount4.id}")
  end

  it "I can click on an 'Edit Discount' link and be taken to form" do
    visit "/merchant/discounts"

    within("#discount-#{@discount1.id}") do
      click_link "Edit Discount"
    end

    expect(current_path).to eql("/merchant/discounts/#{@discount1.id}/edit")
  end

  it "I can click a 'Delete Discount' link and remove discount from app and db" do
    visit "/merchant/discounts"

    within("#discount-#{@discount2.id}") do
      click_link "Delete Discount"
    end
    expect(current_path).to eql("/merchant/discounts")
    @merchant1.reload
    visit current_path

    expect(page).to have_no_css("#discount-#{@discount2.id}")
  end
end
