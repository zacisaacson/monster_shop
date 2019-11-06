require 'rails_helper'

RSpec.describe 'As a default user' do
  before :each do
    @user = User.create!(name: "Gmoney", email: "test@gmail.com", password: "password123", password_confirmation: "password123")
    @user_address = @user.addresses.create!(nickname: "Work" , address: "456 W Broadway St", city: "Denver" , state: "CO", zip: 89043 )

    visit '/login'

    fill_in :email, with: 'test@gmail.com'
    fill_in :password, with: 'password123'

    click_button 'Login'
  end

  it 'can see all profile data expect password' do
    visit '/profile'

    within '.profile-info' do
      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)
      expect(page).to_not have_content(@user.password)
    end

    within '.address-info' do
      expect(page).to have_content(@user_address.nickname)
      expect(page).to have_content(@user_address.address)
      expect(page).to have_content(@user_address.city)
      expect(page).to have_content(@user_address.state)
      expect(page).to have_content(@user_address.zip)
    end
  end

  it 'can prepopulate form to update profile info' do
    visit '/profile'

    click_link 'Edit Your Info'

    expect(current_path).to eq('/profile/edit')

    expect(page).to have_selector("input[value='Gmoney']")
    expect(page).to have_selector("input[value='test@gmail.com']")
    expect(page).to_not have_selector("input[value='123 Lincoln St']")
    expect(page).to_not have_selector("input[value='Denver']")
    expect(page).to_not have_selector("input[value='CO']")
    expect(page).to_not have_selector("input[value='23840']")
  end

  it 'can click a button to edit profile data' do
    visit '/profile/edit'

    fill_in :name, with: 'Billy Bob'
    fill_in :email, with: 'billy.bob@gmail.com'

    click_button 'Update Info'

    expect(current_path).to eq('/profile')
    expect(page).to have_content('You have succesfully updated your information!')

    within '.profile-info' do
      expect(page).to have_content('Billy Bob')
      expect(page).to have_content('billy.bob@gmail.com')
    end
  end

  it 'sees flash messages if fields are blank' do
    visit '/profile/edit'

    fill_in :name, with: ''
    fill_in :email, with: 'billy.bob@gmail.com'

    click_button 'Update Info'

    expect(current_path).to eq('/profile')
    expect(page).to have_content("Name can't be blank")
  end


  it 'can click a button to update password' do
    visit '/profile'

    click_link 'Change Your Password'

    expect(current_path).to eq('/profile/edit')

    fill_in :password, with: 'gmoneyisgreat'
    fill_in :password_confirmation, with: 'gmoneyisgreat'

    click_button 'Update Password'

    expect(current_path).to eq('/profile')
    expect(page).to have_content('You have successfully updated your password!')
  end

  it 'cannot change password if password field is blank' do
    visit '/profile/edit?info=false'

    fill_in :password, with: ''
    fill_in :password_confirmation, with: 'gmoneyisawesome'

    click_button 'Update Password'

    expect(current_path).to eq('/profile')

    expect(page).to have_content('Please fill in both password fields')

    expect(page).to have_field :password
    expect(page).to have_field :password_confirmation
  end

  it "cannot change password if both fields are filled in but don't match" do
    visit '/profile/edit?info=false'

    fill_in :password, with: 'gmoneyiswack'
    fill_in :password_confirmation, with: 'gmoneyisawesome'

    click_button 'Update Password'

    expect(current_path).to eq('/profile')

    expect(page).to have_content('Password confirmation doesn\'t match Password')
  end

  it "shows a link to orders if user has orders" do
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    order_1 = Order.create!(user_id: @user.id, address_id: @user_address.id)
    order_1.item_orders.create!(item_id: tire.id, price: tire.price, quantity: 2)

    visit '/profile'

    click_link 'Your Orders'

    expect(current_path).to eq('/profile/orders')
  end

  it "does't have link to orders if user doesn't have any orders" do
    visit '/profile'

    expect(page).to_not have_link('Your Orders')
  end
end
