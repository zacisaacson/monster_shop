class AddressesController < ApplicationController
  def index
    @addresses = current_user.addresses
  end

  def edit
    @address = Address.find(params[:id])
  end

  def new
  end

  def create
    @user = current_user
    address = @user.addresses.create(address_params)
    if address.save
      redirect_to '/profile/addresses'
    else
      flash.now[:error] = address.errors.full_messages
      render :new
    end
  end

  def update
    @address = Address.find(params[:id])
    @address.update(address_params)
    if @address.save
      redirect_to "/profile/addresses"
    else
      flash.now[:error] = @address.errors.full_messages
      render :edit
    end
  end

  def destroy
    Address.destroy(params[:id])
    redirect_to '/profile/addresses'
  end

private

  def address_params
    params.permit(:nickname,:address,:city,:state,:zip)
  end
end
