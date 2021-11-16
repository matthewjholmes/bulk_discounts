class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  validates_presence_of :item_id
  validates_presence_of :invoice_id
  validates_presence_of :quantity
  validates_presence_of :unit_price
  validates_presence_of :status

  def self.incomplete_inv
    self.where(status: ['pending', 'packaged'])
  end

  def best_discount
    bulk_discounts.where("bulk_discounts.quantity_threshold <= ?", quantity)
                  .order(percentage_discount: :desc)
                  .first
  end

  def revenue
    unit_price * quantity
  end

  def discount_percentage
    best_discount.percentage_discount.to_f / 100
  end

  def discounted_revenue
    if best_discount.nil?
      revenue
    else
      revenue * (1 - discount_percentage)
    end
  end
end
