class Address < ApplicationRecord
  validates_presence_of :nickname, :address, :city, :state, :zip

  belongs_to :user
end
