class AddressesController < ApplicationController
  def index
    @addresses = current_user.addresses
  end
  def edit
    @address = Address.find(params[:id])
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
end
