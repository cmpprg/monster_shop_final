require "rails_helper"

RSpec.describe "As a user, when I add enough quantity to cart." do
  before(:each) do
    @merchant1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @item1 = @merchant1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 100, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
    @item2 = @merchant1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
    @merchant_user = @merchant1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
    @discount1 = @merchant1.discounts.create!(min_quantity: 2, percentage: 20)
  end

  it "I see discount automatically show up on the cart page" do
    visit item_path(@item1)
    click_button("Add to Cart")

    visit cart_path
    within("#item-#{@item1.id}") do
      expect(page).to have_content("Price: $100.00")
    end
    within("#item-#{@item1.id}") do
      click_button "More of This!"
    end
    within("#item-#{@item1.id}") do
      expect(page).to have_content("Price: $80.00, 20% off")
      expect(page).to have_content("Subtotal: $160.00")
    end
  end


end
