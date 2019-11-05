require 'rails_helper'

RSpec.describe 'As a default user' do
  before :each do
    @user = User.create!(name: "Gmoney", address: "123 Lincoln St", city: "Denver", state: "CO", zip: 23840, email: "test@gmail.com", password: "password123", password_confirmation: "password123")
    @work = @user.addresses.create!(nickname: "Work" , address: "456 W Broadway St", city: "Denver" , state: "CO", zip: 89043 )
    @home = @user.addresses.create!(nickname: "Home" , address: "400 Washington St", city: "Denver" , state: "CO", zip: 89233 )
    @parents = @user.addresses.create!(nickname: "Parents" , address: "4739 N Wilshire Dr", city: "Phoenix" , state: "AZ", zip: 84839 )

    visit '/login'

    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password123'

    click_button 'Login'
  end

  it "can index all addresses" do
    visit '/profile'

    click_link 'Addresses'

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
