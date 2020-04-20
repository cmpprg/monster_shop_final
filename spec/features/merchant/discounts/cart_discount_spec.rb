require "rails_helper"

RSpec.describe "As a user, when I add enough quantity to cart." do
  before(:each) do
    @merchant1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @merchant2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

    @item1 = @merchant1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 100, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
    @item2 = @merchant1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
    @item3 = @merchant2.items.create!(name: 'Unicorn', description: "I'm a Unicorn!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
    @merchant_user = @merchant1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
    @discount1 = @merchant1.discounts.create!(min_quantity: 3, percentage: 20)
    @discount1 = @merchant1.discounts.create!(min_quantity: 6, percentage: 30)
    @discount1 = @merchant1.discounts.create!(min_quantity: 4, percentage: 40)

  end

  it "I see discount automatically show up on the cart page" do
    visit item_path(@item1)
    click_button("Add to Cart")

    visit cart_path
    within("#item-#{@item1.id}") do
      expect(page).to have_content("Price: $100.00")
    end

    2.times do
      within("#item-#{@item1.id}") do
        click_button "More of This!"
      end
    end

    within("#item-#{@item1.id}") do
      expect(page).to have_content("Price: $80.00, 20% off")
      expect(page).to have_content("Subtotal: $240.00")
    end
  end

  it "discount from one merchant will only affect items from that merchant in cart" do
    visit item_path(@item1)
    click_button("Add to Cart")

    visit item_path(@item3)
    click_button("Add to Cart")

    visit cart_path

    within("#item-#{@item1.id}") do
      expect(page).to have_content("Price: $100.00")
    end
    within("#item-#{@item3.id}") do
      expect(page).to have_content("Price: $20.00")
    end

    2.times do
      within("#item-#{@item1.id}") do
        click_button "More of This!"
      end
    end
    2.times do
      within("#item-#{@item3.id}") do
        click_button "More of This!"
      end
    end

    within("#item-#{@item1.id}") do
      expect(page).to have_content("Price: $80.00, 20% off")
    end
    within("#item-#{@item3.id}") do
      expect(page).to have_content("Price: $20.00")
    end
  end

  it "A discount only effects the single item that has reached necessary quantity,
      does not affect other items from same merchant" do

      visit item_path(@item1)
      click_button("Add to Cart")

      visit item_path(@item2)
      click_button("Add to Cart")

      visit cart_path

      within("#item-#{@item1.id}") do
        expect(page).to have_content("Price: $100.00")
      end
      within("#item-#{@item2.id}") do
        expect(page).to have_content("Price: $50.00")
      end

      2.times do
        within("#item-#{@item1.id}") do
          click_button "More of This!"
        end
      end
      within("#item-#{@item2.id}") do
        click_button "More of This!"
      end

      within("#item-#{@item1.id}") do
        expect(page).to have_content("Price: $80.00, 20% off")
      end
      within("#item-#{@item2.id}") do
        expect(page).to have_content("Price: $50.00")
      end
  end

  it "if there is conflict between two discounts, the greater of the two will be applied." do
    @merchant1.discounts.create!(min_quantity: 6, percentage: 30)
    @merchant1.discounts.create!(min_quantity: 4, percentage: 40)

    visit item_path(@item1)
    click_button("Add to Cart")

    visit cart_path
    within("#item-#{@item1.id}") do
      expect(page).to have_content("Price: $100.00")
    end

    5.times do
      within("#item-#{@item1.id}") do
        click_button "More of This!"
      end
    end


    within("#item-#{@item1.id}") do
      expect(page).to have_content("Price: $60.00, 40% off")
      expect(page).to have_content("Subtotal: $360.00")
    end
  end
end
