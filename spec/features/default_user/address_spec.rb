require 'rails_helper'

RSpec.describe 'As a default user' do
  before :each do
    @user = User.create!(name: "Gmoney", email: "test@gmail.com", password: "password123", password_confirmation: "password123")
    @work = @user.addresses.create!(nickname: "Work" , address: "456 W Broadway St", city: "Denver" , state: "CO", zip: 89043 )
    @home = @user.addresses.create!(nickname: "Home" , address: "400 Washington St", city: "Denver" , state: "CO", zip: 89233 )
    @parents = @user.addresses.create!(nickname: "Parents" , address: "4739 N Wilshire Dr", city: "Phoenix" , state: "AZ", zip: 84839 )

    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @order_1 = Order.create!(user_id: @user.id, address_id: @work.id)
    @order_2 = Order.create!(user_id: @user.id, address_id: @home.id, status: 2)
    @order_1.item_orders.create!(item_id: @tire.id, price: @tire.price, quantity: 2)
    @order_1.item_orders.create!(item_id: @paper.id, price: @paper.price, quantity: 1)

    visit '/login'

    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password123'

    click_button 'Login'
  end

  it "can index all addresses" do
    visit '/profile'

    click_link 'Edit Address'

    expect(current_path).to eq('/profile/addresses')

    within "#addresses-#{@work.id}" do
      expect(page).to have_content('Work')
      expect(page).to have_content('456 W Broadway St')
      expect(page).to have_content('Denver')
      expect(page).to have_content('CO')
      expect(page).to have_content(89043)
    end

    within "#addresses-#{@home.id}" do
      expect(page).to have_content('Home')
      expect(page).to have_content('400 Washington St')
      expect(page).to have_content('Denver')
      expect(page).to have_content('CO')
      expect(page).to have_content(89233)
    end
  end

  it "can edit addresses and prepopulate" do
    visit '/profile/addresses'

    within "#addresses-#{@work.id}" do
      click_link('Edit Address')
    end

    expect(current_path).to eq("/profile/addresses/#{@work.id}/edit")

    expect(page).to have_selector("input[value='Work']")
    expect(page).to have_selector("input[value='456 W Broadway St']")
    expect(page).to have_selector("input[value='Denver']")
    expect(page).to have_selector("input[value='CO']")
    expect(page).to have_selector("input[value='89043']")

    fill_in :nickname, with: 'No Where'
    fill_in :address, with: '3432 W 3rd Ave'
    fill_in :city, with: 'Aurora'
    fill_in :state, with: 'CO'
    fill_in :zip, with: 83940

    click_button('Update Address')

    expect(current_path).to eq('/profile/addresses')

    within "#addresses-#{@work.id}" do
      expect(page).to have_content('No Where')
      expect(page).to have_content('432 W 3rd Ave')
      expect(page).to have_content('Aurora')
      expect(page).to have_content('CO')
      expect(page).to have_content(83940)
    end
  end

  it "will show flash message and redirect if form not filled out properly" do

    visit "/profile/addresses/#{@work.id}/edit"

    fill_in :nickname, with: ''
    fill_in :address, with: '3432 W 3rd Ave'
    fill_in :city, with: 'Aurora'
    fill_in :state, with: 'CO'
    fill_in :zip, with: 83940

    click_button('Update Address')

    expect(current_path).to eq("/profile/addresses/#{@work.id}")

    expect(page).to have_content("Nickname can't be blank")
  end

  it "can create a new address" do
    visit '/profile/addresses'

    click_link "Add New Address"

    expect(current_path).to eq("/profile/addresses/new")

    fill_in :nickname, with: 'Somewhere'
    fill_in :address, with: '9872 Lake St'
    fill_in :city, with: 'Lakewood'
    fill_in :state, with: 'CO'
    fill_in :zip, with: 83480

    click_button 'Create Address'

    expect(current_path).to eq('/profile/addresses')

    new_item = Address.last

    within "#addresses-#{new_item.id}" do
      expect(page).to have_content('Somewhere')
      expect(page).to have_content('9872 Lake St')
      expect(page).to have_content('Lakewood')
      expect(page).to have_content('CO')
      expect(page).to have_content(83480)
    end
  end

  it "will show a flash message and render if form not filled out" do
    visit '/profile/addresses/new'

    fill_in :nickname, with: ''
    fill_in :address, with: '9872 Lake St'
    fill_in :city, with: ''
    fill_in :state, with: 'CO'
    fill_in :zip, with: 83480

    click_button 'Create Address'

    expect(current_path).to eq('/profile/addresses')

    expect(page).to have_content("Nickname can't be blank\nCity can't be blank")
  end

  it "can delete an address" do
    visit '/profile/addresses'

    within "#addresses-#{@work.id}" do
      click_link 'Delete Address'
    end

    expect(current_path).to eq('/profile/addresses')

    expect("addresses-#{@work.id}").to be_present
  end

  it "can edit an address that hasnt been shipped" do
    visit '/profile/orders'

    within "#order-#{@order_1.id}" do
      click_button "Change Address"
    end

    expect(current_path).to eq("/profile/orders/#{@order_1.id}/edit")

    within "#addresses-#{@work.id}" do
      click_link 'Select'
    end

    expect(current_path).to eq("/profile")

    expect(page).to have_content('Your address has been updated')

  end

  it "cannot edit an address that has been shipped" do
    visit '/profile/orders'

    within "#order-#{@order_2.id}" do
      expect(page).to_not have_link('Change Address')
    end

  end
end
