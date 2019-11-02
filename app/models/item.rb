class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]

  validates_numericality_of :price
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, only_integer: true
  validates_numericality_of :inventory, greater_than_or_equal_to: 0

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.active_only
    where(active?: true)
  end

  def quantity_ordered
    item_orders.sum(:quantity)
  end

  def self.top_five_ordered
    joins(:item_orders).group('items.id').order('sum(item_orders.quantity) DESC').limit(5)
  end

  def self.bottom_five_ordered
    joins(:item_orders).group('items.id').order('sum(item_orders.quantity)').limit(5)
  end

  def reduce_inventory(quantity)
    self.inventory -= quantity
  end

  def increase_inventory(quantity)
    self.inventory += quantity
  end
end
