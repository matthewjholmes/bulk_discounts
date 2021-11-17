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

  def revenue
    unit_price * quantity
  end

  def best_discount
    bulk_discounts.where("bulk_discounts.quantity_threshold <= ?", quantity)
                  .order(percentage_discount: :desc)
                  .first
  end

  def discount_percentage
    best_discount.percentage_discount.to_f / 100
  end

  def discounted_revenue_by_merchant(merchant_id)
    if best_discount.nil?
      0
    else
      if best_discount.merchant.id == merchant_id
        if best_discount.nil?
          revenue
        else
          revenue * (1 - discount_percentage)
        end
      else
        0
      end
    end
  end

  def discounted_revenue
    if best_discount.nil?
      revenue
    else
      revenue * (1 - discount_percentage)
    end
  end
end
