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
      flash[:success] = ["#{address.nickname} address successfully created"]
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
      flash[:success] = ["#{@address.nickname} address has been updated"]
      redirect_to "/profile/addresses"
    else
      flash.now[:error] = @address.errors.full_messages
      render :edit
    end
  end

  def destroy
    address = Address.find(params[:id])
    if address.unshipped_orders
      address.unshipped_orders.destroy_all
      address.delete
    end
    flash[:error] = ["#{address.nickname} address has been deleted"]
    redirect_to '/profile/addresses'
  end

private

  def address_params
    params.permit(:nickname,:address,:city,:state,:zip)
  end
end
