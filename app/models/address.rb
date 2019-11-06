class Address < ApplicationRecord
  validates_presence_of :nickname, :address, :city, :state, :zip

  belongs_to :user
  has_many :orders

  validates_numericality_of :zip, only_integer: true
  validates_length_of :zip, is: 5

  def shipped_orders?
    orders.where(status: 2).exists?
  end

  def unshipped_orders
    orders.where('status != 2')
  end

end
