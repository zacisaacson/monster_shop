require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add Item to Cart"
      visit "/items/#{@tire.id}"
      click_on "Add Item to Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add Item to Cart"
      @items_in_cart = [@paper,@tire,@pencil]

      @user = User.create!(name: "Gmoney", email: "test@gmail.com", password: "password123", password_confirmation: "password123")
      @user_address = @user.addresses.create!(
        nickname: 'Home',
        address: '9247 E 42nd Avenue',
        city: 'Rochester',
        state: 'NY',
        zip: 48231
      )
      visit '/login'
      fill_in :email, with: 'test@gmail.com'
      fill_in :password, with: 'password123'
      click_button 'Login'
    end

    it 'Theres a link to select address' do
      visit "/cart"

      within "#addresses-#{@user_address.id}" do
        click_link "Select"
      end

      expect(current_path).to eq("/profile/orders/#{@user_address.id}/new")

      click_on "Checkout"

      expect(current_path).to eq("/profile/orders")
    end
  end

  describe 'When I havent added items to my cart' do
    before(:each) do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
  end

    it 'no link to select address and flash message' do
      visit "/cart"

      expect(page).to_not have_link("Edit Address")

      
    end
  end
end
