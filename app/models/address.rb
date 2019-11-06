class Address < ApplicationRecord
  validates_presence_of :nickname, :address, :city, :state, :zip

  belongs_to :user
  has_many :orders

  validates_numericality_of :zip, only_integer: true
  validates_length_of :zip, is: 5
end
