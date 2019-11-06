class User < ApplicationRecord
  validates_presence_of :name
  validates :email, uniqueness: true, presence: true
  has_secure_password
  has_many :orders
  has_many :addresses
  belongs_to :merchant, optional: true

  enum role: %w(default merchant_employee merchant_admin admin)

  def titleize_role
    role.titleize
  end
end
