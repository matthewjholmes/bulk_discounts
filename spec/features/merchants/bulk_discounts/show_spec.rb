require 'rails_helper'

RSpec.describe 'Bulk Discount index page' do
  before do
    @merchant = create :merchant
    @discount = create :bulk_discount, { merchant_id: @merchant.id }

    visit merchant_bulk_discount_path(@merchant, @discount)
  end

  it 'when i visit my bulk discount show page' do
    expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount))
  end

  it 'i see the discount percentage_discount and quantity_threshold' do
    expect(page).to have_content(@discount.percentage_discount)
    expect(page).to have_content(@discount.quantity_threshold)
  end
end
